<template>
  <b-card
    no-body
    class="namespace-item h-100 shadow-sm mb-4"
    :class="{ 'shadow': hovered }"
    @mouseover="hovered = true"
    @mouseleave="hovered = false"
  >
    <b-card-img
      v-if="namespace.meta.logoEnabled"
      :src="logo"
      :alt="namespace.name"
      class="p-2"
    />

    <b-card-body
      class="mw-100"
      :class="{ 'pb-0': showFooter }"
    >
      <div
        class="d-flex align-items-center"
        :class="{ 'h-100': !namespace.meta.description }"
      >
        <div
          class="d-flex flex-column justify-content-center w-100"
        >
          <h5
            class="mb-0 mw-100"
          >
            {{ namespace.name }}
          </h5>
          <p
            v-if="namespace.meta.subtitle"
            class="d-inline-block mb-0 mt-1"
          >
            {{ namespace.meta.subtitle }}
          </p>
        </div>
      </div>

      <p
        v-if="namespace.meta.description"
        class="overflow-auto mb-0 mt-2"
      >
        <small>{{ namespace.meta.description }}</small>
      </p>
    </b-card-body>

    <b-card-footer
      v-if="showFooter"
      footer-bg-variant="white"
    >
      <b-button-group
        class="mt-2 d-block d-md-flex"
      >
        <b-button
          v-if="isEnabled"
          :to="{ name: 'pages', params: { slug: (namespace.slug || namespace.namespaceID) } }"
          :aria-label="$t('visit') + ' ' + namespace.name"
          variant="light"
          class="d-flex align-items-center justify-content-center mb-1 mb-md-0"
        >
          {{ $t('visit') }}
        </b-button>
        <b-button
          v-if="canEdit"
          :to="{ name: 'namespace.edit', params: { namespaceID: namespace.namespaceID } }"
          :aria-label="$t('edit') + ' ' + namespace.name"
          variant="light"
          class="d-flex align-items-center justify-content-center ml-md-1"
        >
          {{ $t('general:label.edit') }}
        </b-button>
        <b-button
          variant="light"
          class="d-flex align-items-center justify-content-center ml-md-1"
          @click="onExportClick(namespace)"
        >
          Download source code
        </b-button>
      </b-button-group>
    </b-card-footer>
  </b-card>
</template>
<script>
import { automation } from '@cortezaproject/corteza-js'

export default {
  i18nOptions: {
    namespaces: 'namespace',
  },

  props: {
    namespace: {
      type: Object,
      required: true,
    },
  },

  data () {
    return {
      processing: false,
      hovered: undefined,
      logoAttachment: undefined,
    }
  },

  computed: {
    isEnabled () {
      return !!this.namespace.enabled
    },

    canEdit () {
      return !!this.namespace.canUpdateNamespace
    },

    showFooter () {
      return this.isEnabled || this.canEdit
    },

    logo () {
      return this.namespace.meta.logo || this.$Settings.attachment('ui.mainLogo')
    },
  },

  methods: {
    onExportClick (namespaceID) {
      const downloadWorkflow = this.getDownloadWorkflow()
      const input = automation.Encode({ namespace: namespaceID })

      this.processing = true
      downloadWorkflow.then((dw) => {
        const { workflowID, stepID } = dw

        this.$AutomationAPI.workflowExec({ workflowID, stepID, input })
          .then(() => {
            setTimeout(() => {
              this.$store.dispatch('wfPrompts/update')
            }, 500)
          })
          .catch(this.toastErrorHandler(this.$t('notification:automation.scriptFailed')))
          .finally(() => {
            this.processing = false
          })
      })
    },

    async getDownloadWorkflow () {
      const triggerList = await this.$AutomationAPI.triggerList({ eventType: 'onManual' })
        .then(({ set } = {}) => {
          return set.map(({ triggerID, workflowID, resourceType, stepID }) => ({ triggerID, workflowID, resourceType, stepID }))
        })
        .catch(err => {
          console.error(err)
        })

      const workflowIDs = triggerList.map(({ workflowID }) => workflowID)

      const workflowList = await this.$AutomationAPI.workflowList({ workflowIDs })
        .then(({ set } = {}) => {
          const downloadWorkflow = set.filter(({ handle }) => handle === 'test_wf')
          return downloadWorkflow[0]
        })

      return triggerList.filter(({ workflowID }) => workflowID === workflowList.workflowID)[0]
    },
  },
}
</script>

<style lang="scss" scoped>
.namespace-item {
  top: 0;

  &:hover {
    transition: all 0.2s ease;
    top: -1px;
  }
}
</style>
