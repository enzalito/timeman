<script setup lang="ts">
import { RouterView } from "vue-router"
import Layout from "@/components/layout/Layout.vue"

//document.body.style.zoom = "120%"
</script>

<template>
  <Layout>
    <RouterView />

    <Card title="Card title">
      card content Lorem ipsum dolor sit amet consectetur adipisicing elit. Nam at totam eveniet
      doloremque, molestiae corrupti molestias iusto officiis ipsam delectus similique porro aperiam
      harum fugit architecto quod, eaque perspiciatis modi?
    </Card>
  </Layout>
</template>
