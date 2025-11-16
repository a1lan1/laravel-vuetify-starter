import axios from './axios'
import pinia from './pinia'
import vuetify from './vuetify'
import type { App } from 'vue'

export function registerPlugins(app: App) {
  app
    .use(axios)
    .use(pinia)
    .use(vuetify)
}
