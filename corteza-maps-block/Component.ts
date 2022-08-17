import { PageBlock, PageBlockInput, Registry } from './base'
import { Apply, CortezaID, NoID } from '../../../cast'

const kind = 'Componentkind'

interface Options {
  moduleID: string;
  deviceRecord: string;
  datasource: string;
}

const defaults: Readonly<Options> = Object.freeze({
  moduleID: NoID,
  deviceRecord: '',
  datasource:'',
})

export class PageBlockComponent extends PageBlock {
  readonly kind = kind

  options: Options = { ...defaults }

  constructor (i?: PageBlockInput) {
    super(i)
    this.applyOptions(i?.options as Partial<Options>)
  }

  applyOptions (o?: Partial<Options>): void {
    if (!o) return
    Apply(this.options, o, CortezaID, 'moduleID')
    Apply(this.options, o, String, 'deviceRecord' , 'datasource')
  }
}

Registry.set(kind, PageBlockComponent)
