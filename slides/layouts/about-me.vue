<script setup>

const props = defineProps({
    speakerName: {
        type: String,
        required: true,
    },
    speakerTitle: {
        type: String,
        required: true,
    },
    speakerImage: {
        type: String,
        required: true,
    },
    speakerCompanyLogo: {
        type: String,
        required: true,
    },
    orcImage: {
        type: String,
        required: true,
    }
})
</script>

<template>
  <div class="slidev-layout about-me">
    <div class="flex items-center h-full">
      <img src="/speaker.jpeg" class="flex absolute -z-1 left-5/7 h-full">
      <div class="flex flex-col gap-4 w-2/5">
        <h1 class="text-6xl">{{ props.speakerName }}</h1>
        <span class="mt-2">{{ props.speakerTitle }}</span>
        <ul>
          <slot name="details" />
        </ul>
        <div class="flex two-columns">
          <img :src="orcImage" class="slidev-icon w-6em" >
          <img :src="speakerCompanyLogo" class="slidev-icon w-12em" >
        </div>
      </div>
      <figure class="flex justify-center">
        <img
          :src="speakerImage"
          class="rounded-full h-80 w-80 border border-6 border-sky-600"
        />
      </figure>
    </div>
  </div>
</template>
