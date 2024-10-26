interface QueuedRequest {
  timestamp: number
  url: string
  method: string
  headers: Record<string, string>
  body: string | null
}

class OfflineQueue {
  private dbName: string
  private storeName: string
  private db: IDBDatabase | null
  public isProcessing: boolean

  constructor() {
    this.dbName = "offlineQueueDB"
    this.storeName = "pendingRequests"
    this.db = null
    this.isProcessing = false
    this.initDB()
  }

  private async initDB(): Promise<void> {
    return new Promise((resolve, reject) => {
      const request = indexedDB.open(this.dbName, 1)

      request.onerror = () => reject(request.error)
      request.onsuccess = () => {
        this.db = request.result
        resolve()
      }

      request.onupgradeneeded = (event) => {
        const db = (event.target as IDBOpenDBRequest).result
        if (!db.objectStoreNames.contains(this.storeName)) {
          db.createObjectStore(this.storeName, {
            keyPath: "timestamp"
          })
        }
      }
    })
  }

  public async addToQueue(request: Request): Promise<void> {
    if (!this.db) {
      throw new Error("Database not initialized")
    }

    const requestData: QueuedRequest = {
      timestamp: Date.now(),
      url: request.url,
      method: request.method,
      headers: Object.fromEntries(request.headers.entries()),
      body: await request.clone().text()
    }

    return new Promise((resolve, reject) => {
      const transaction = this.db!.transaction([this.storeName], "readwrite")
      const store = transaction.objectStore(this.storeName)
      const addRequest = store.add(requestData)

      addRequest.onsuccess = () => {
        resolve()
      }
      addRequest.onerror = () => reject(addRequest.error)
    })
  }

  public async processQueue(): Promise<void> {
    if (!this.db) {
      throw new Error("Database not initialized")
    }
    if (this.isProcessing) {
      throw new Error("Already processing")
    }
    this.isProcessing = true

    const requests = await this.getQueuedRequests()

    for (const request of requests) {
      try {
        await this.executeRequest(request)
      } catch (error) {
        console.error("Failed to process request:", error)
      }
      await this.removeFromQueue(request.timestamp)
    }
    this.isProcessing = false
  }

  async getQueuedRequests(): Promise<QueuedRequest[]> {
    if (!this.db) {
      throw new Error("Database not initialized")
    }

    return new Promise((resolve, reject) => {
      const transaction = this.db!.transaction([this.storeName], "readonly")
      const store = transaction.objectStore(this.storeName)
      const getRequest = store.getAll()

      getRequest.onsuccess = () => resolve(getRequest.result)
      getRequest.onerror = () => reject(getRequest.error)
    })
  }

  async removeFromQueue(timestamp: number): Promise<void> {
    if (!this.db) {
      throw new Error("Database not initialized")
    }

    return new Promise((resolve, reject) => {
      const transaction = this.db!.transaction([this.storeName], "readwrite")
      const store = transaction.objectStore(this.storeName)
      const deleteRequest = store.delete(timestamp)

      deleteRequest.onsuccess = () => resolve()
      deleteRequest.onerror = () => reject(deleteRequest.error)
    })
  }

  async executeRequest(requestData: QueuedRequest): Promise<Response> {
    const request = new Request(requestData.url, {
      method: requestData.method,
      headers: new Headers(requestData.headers),
      body: requestData.method !== "GET" ? requestData.body : null
    })

    return fetch(request)
  }
}

// Custom fetch function that handles offline scenarios
export const offlineQueue = new OfflineQueue()

interface FetchOptions extends RequestInit {
  timeout?: number
}

export async function fetchWithOfflineSupport(
  url: string,
  options: FetchOptions = {}
): Promise<Response> {
  try {
    const response = await fetch(url, options)
    return response
  } catch (error) {
    if (!navigator.onLine) {
      // Store the request for later
      await offlineQueue.addToQueue(new Request(url, options))
      throw new Error("Offline: Request queued for later")
    }
    throw error
  }
}
