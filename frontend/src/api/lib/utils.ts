type QueryParams = Record<string, string | number | boolean>

function toQueryParams(params?: QueryParams): string {
  const paramsStr: string[] = []
  for (let key in params) {
    if (params[key] === undefined) {
      continue
    }

    const keySnakeCase = key.replace(/[A-Z]/g, (letter) => `_${letter.toLowerCase()}`)
    paramsStr.push(`${keySnakeCase}=${params[key].toString()}`)
  }

  return paramsStr.join("&")
}
