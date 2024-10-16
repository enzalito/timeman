<script setup lang="ts">
import { ref, onBeforeMount } from "vue"

import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import {
  Table,
  TableBody,
  TableCaption,
  TableCell,
  TableHead,
  TableHeader,
  TableRow
} from "@/components/ui/table"
import { useUserStore } from "@/stores/user"
import { getWorkingTimes, type WorkingTimeBulkResponse } from "@/api/workingTime"

const tabData = ref<WorkingTimeBulkResponse>({ data: [] })

onBeforeMount(async () => {
  const userStore = useUserStore()
  if (userStore.user) {
    tabData.value = await getWorkingTimes(userStore.user.id)
  }
})
</script>

<template>
  <Card class="inline-block w-auto h-auto mt-10 py-5 px-3 border border-gray-300 rounded-lg">
    <CardHeader>
      <CardTitle class="flex justify-center font-bold">My working hours</CardTitle>
    </CardHeader>

    <CardContent>
      <Table class="border-separate border-spacing-3">
        <TableCaption>A list of your working hours.</TableCaption>

        <TableHeader>
          <TableRow>
            <TableHead>Date d'entrée</TableHead>
            <TableHead>Date de sortie</TableHead>
          </TableRow>
        </TableHeader>

        <TableBody>
          <TableRow v-for="(item, index) in tabData.data" :key="index" class="bordered-row">
            <TableCell class="border border-gray-300 py-3 px-5 rounded-full">{{
              item.start
            }}</TableCell>
            <TableCell class="border border-gray-300 py-3 px-5 rounded-full">{{
              item.end
            }}</TableCell>
          </TableRow>
        </TableBody>
      </Table>
    </CardContent>
  </Card>
</template>
