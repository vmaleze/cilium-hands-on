<script setup lang="ts">
const props = defineProps({
  classLeft: {
    type: String,
  },
  classRight: {
    type: String,
  },
  layoutClass: {
    type: String,
  },
})
</script>

<template>
  <div class="slidev-layout two-columns w-full h-full grid grid-cols-3" :class="props.layoutClass">
    <div :class="props.classLeft">
      <slot />
    </div>
    <div :class="props.classRight">
      <slot name="right" />
    </div>
  </div>
</template>