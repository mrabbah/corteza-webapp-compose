<template>
  <c-translator-button
    v-if="canManageResourceTranslations && resourceTranslationsEnabled"
    v-bind="$props"
    class="ml-auto py-1 px-3"
    :resource="resource"
    :titles="titles"
    :fetcher="fetcher"
    :updater="updater"
  />
</template>

<script>
import { compose } from '@cortezaproject/corteza-js'
import { mapGetters } from 'vuex'
import CTranslatorButton from 'corteza-webapp-compose/src/components/Translator/CTranslatorButton'

export default {
  components: {
    CTranslatorButton,
  },

  i18nOptions: {
    namespaces: 'resource-translator',
    keyPrefix: 'resources.chart',
  },

  props: {
    field: {
      type: String,
      default: '',
    },

    chart: {
      type: compose.Chart,
      required: true,
    },

    // report: {
    //   type: Object,
    //   default: () => ({}),
    //   required: true,
    // },

    // highlights selected string
    highlightKey: {
      type: String,
      default: '',
    },

    // buttonVariant: {
    //   type: String,
    //   default: () => 'primary',
    // },

    // buttonClass: {
    //   type: String,
    //   default: () => { return '' },
    // },

    disabled: {
      type: Boolean,
      default: () => false,
    },
  },

  computed: {
    ...mapGetters({
      can: 'rbac/can',
    }),

    canManageResourceTranslations () {
      return this.can('compose/', 'resource-translations.manage')
    },

    // key of the string to be translated
    resource () {
      const { namespaceID, chartID } = this.chart
      return `compose:chart/${namespaceID}/${chartID}`
    },

    // contains all of the translations for a single string;
    // for the different languages
    titles () {
      const { chartID, handle } = this.chart
      const titles = {}

      titles[this.resource] = this.$t('title', { handle: handle || chartID })

      // maybe I won;t need this
      // fields.forEach(({ chartID, name }) => {
      //   titles[`compose:chart/${namespaceID}/${chartID}`] = this.$t('chart.title', { name })
      // })

      return titles
    },

    // fetches translations
    fetcher () {
      const { namespaceID, chartID } = this.chart

      return () => {
        return this.$ComposeAPI.chartListTranslations({ namespaceID, chartID })
          // .then(result => {
          //   debugger
          //   const key = result.key
          // })
        // @todo pass set of translations to the resource object
        // The logic there needs to be implemented; the idea is to decode
        // values from the resource object to the set of translations)
      }
    },

    // updates translations
    updater () {
      // return false
      const { namespaceID, chartID } = this.chart

      return translations => {
        return this.$ComposeAPI
          .chartUpdateTranslations({ namespaceID, chartID, translations })
          // re-fetch translations, sanitized and stripped
          .then(() => this.fetcher())
          .then((translations) => {
            // When translations are successfully saved,
            // scan changes and apply them back to the passed object
            // not the most elegant solution but is saves us from
            // handling the resource on multiple places
            //
            //
            // @todo move this to Namespace* classes
            // the logic there needs to be implemented; the idea is to encode
            // values from the set of translations back to the resource object
            const find = (key) => {
              return translations.find(t => t.key === key && t.lang === this.currentLanguage && t.resource === this.resource)
            }

            const tr = find('name')
            if (tr !== undefined) {
              this.chart.name = tr.message
            }

            return this.chart
          })
          .then(chart => {
            this.$emit('update:chart', chart)
          })
      }
    },
  },
}
</script>
