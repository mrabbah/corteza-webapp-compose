<template>
  <b-tab title="Map Config">
    <b-form-group
      id="fieldset-1"
      description="Let us know your name."
      label="Enter your name"
      label-for="input-1"
      valid-feedback="Thank you!"
       
    >
      <b-form-input v-model="options.deviceRecord" />
    </b-form-group>
    <b-form-group
      id="fieldset-1"
      description="Let us know your name."
      label="Data source"
      label-for="input-1"
      valid-feedback="Thank you!"
    >
      <b-form-input v-model="options.datasource" />
    </b-form-group>
  </b-tab>
</template>
<script>
import { mapGetters } from 'vuex'
import { NoID } from '@cortezaproject/corteza-js'
import base from './base'

export default {
  i18nOptions: {
    namespaces: 'block',
  },

  name: 'MaptConfigurator',

  extends: base,
  data () {
    return {
      referenceList: [{ label: 'Record ID (recordID)', value: 'recordID' }, { label: 'Page ID (pageID)', value: 'pageID' }],
      sortDirections: [{ label: this.$t('comment.sortDirection.asc'), value: 'asc' }, { label: this.$t('comment.sortDirection.desc'), value: 'desc' }],
    }
  },
  computed: {
    ...mapGetters({
      modules: 'module/set',
    }),

    moduleOptions () {
      return [
        { moduleID: NoID, name: this.$t('general.label.none') },
        ...this.filterModulesByRecord,
      ]
    },

    filterModulesByRecord () {
      if (this.record) {
        return this.modules.filter(module => {
          return module.fields.some(f => {
            if (f.kind === 'Record') {
              if (f.options.moduleID === this.options.moduleID) {
                return false
              }
            }
            return true
          })
        })
      }
      return this.modules
    },

    selectedModule () {
      return this.modules.find(m => m.moduleID === this.options.moduleID)
    },

    selectedModuleFields () {
      if (this.selectedModule) {
        return [...this.selectedModule.fields].sort((a, b) => a.label.localeCompare(b.label))
      }
      return []
    },

    allFields () {
      if (this.options.moduleID) {
        return [
          ...this.selectedModuleFields,
          ...this.selectedModule.systemFields().map(sf => {
            sf.label = this.$t(`field:system.${sf.name}`)
            return sf
          }),
        ]
      }
      return []
    },
  },

  watch: {
    'options.moduleID': {
      handler () {
        this.options.titleField = ''
        this.options.contentField = ''
        this.options.referenceField = ''
        this.selectedModuleFields.forEach(f => {
          if (f.name === 'Reference') {
            this.options.referenceField = 'Reference'
          }
          if (f.name === 'Content') {
            this.options.contentField = 'Content'
          }
        })
      },
    },
  },

  created () {
    if (!this.options.sortDirection) {
      this.options.sortDirection = 'desc'
    }
  },
  methods: {
    selectedModuleFieldsByType (type) {
      return (this.selectedModuleFields || []).filter((f) => {
        return f.kind === type
      })
    },
  },
}
</script>
<style lang="scss" scoped>
.fields {
  height: 150px;
  overflow-y: auto;
  cursor: default;
}
</style>
