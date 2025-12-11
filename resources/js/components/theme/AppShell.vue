<script setup lang="ts">
import { SidebarProvider } from '@/components/ui/sidebar'
import { snackbar } from '@/plugins/snackbar'
import type { AppPageProps, FlashMessage } from '@/types'
import { usePage } from '@inertiajs/vue3'
import { watch, nextTick } from 'vue'

interface Props {
  variant?: 'header' | 'sidebar';
}

defineProps<Props>()

const page = usePage<AppPageProps>()
const isOpen = usePage().props.sidebarOpen

const handleFlashMessages = (flash: FlashMessage) => {
  if (!snackbar || !flash) return

  if (flash.success) {
    snackbar.success({
      text: flash.success
    })
  }
  if (flash.error) {
    snackbar.error({
      text: flash.error
    })
  }
  if (flash.message) {
    snackbar.info({
      text: flash.message
    })
  }
}

watch(() => page.props.flash, handleFlashMessages, { deep: true })

watch(() => page.props.quote, (newQuote) => {
  if (newQuote?.message) {
    nextTick(() => {
      snackbar.info({ text: `${newQuote.author}: ${newQuote.message}` })
    })
  }
}, { immediate: true, deep: true })
</script>

<template>
  <div
    v-if="variant === 'header'"
    class="flex min-h-screen w-full flex-col"
  >
    <slot />
  </div>
  <SidebarProvider
    v-else
    :default-open="isOpen"
  >
    <slot />
  </SidebarProvider>
</template>
