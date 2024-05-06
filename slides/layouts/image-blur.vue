<script setup>

const props = defineProps({
    image: {
        type: String,
        required: true,
    },
    imageHeight: {
        type: String,
        required: true
    },
    contentClass: {
        type: String,
        required: true
    }
})

const defaultImageStyle='absolute-center z-0 mt-2rem'
const imageStyle = defaultImageStyle + ' ' + props.imageHeight
const imageBluredStyle = defaultImageStyle + ' op-20 blur-sm ' + props.imageHeight
</script>

<template>
    <div class="slidev-layout image-blur">
        <slot name="header" />
        <div class="grid place-content-center h-6/7">
            <img v-click-hide :src="image" :class="imageStyle" />
            <img v-after :src="image" :class="imageBluredStyle" />
            <div class="z-1">
                <ul :class="contentClass">
                    <slot name="content" />
                </ul>
            </div>
        </div>
    </div>
</template>