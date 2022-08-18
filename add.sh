#!/bin/bash

file="props.properties"

function prop {
    grep "${1}" "${2}/${file}" | cut -d'=' -f2
}


function replaceA {
    sed  -i 's#${1}#${2}#g' ${3}
}



COMP_PATH=${1}
COMP_NAME=$( prop 'compoment.name' ${COMP_PATH} )
COMP_NAME_CAP=${COMP_NAME^}

CORTEZA_JS_PATH=${2}
CORTEZA_COMPOSE_PATH=${3}

PAGE_BLOCK_COMP_NAME_CAP="PageBlock"$COMP_NAME_CAP


COMP_NAME_CAP_BASE="${COMP_NAME_CAP}Base"
COMP_NAME_CAP_CONFIGURATOR="${COMP_NAME_CAP}Configurator"
COMP_NAME_CAP_COMPONENT="${COMP_NAME_CAP}Compoments"





echo "-------corteza-js---------"

echo "cpoy Compoment.ts to corteza-js/src/compose/types/page-block/"
cp $COMP_PATH/Component.ts $CORTEZA_JS_PATH/src/compose/types/page-block/$COMP_NAME.ts

echo "Update Compoment.ts in ./corteza-js/src/compose/types/page-block/index.ts"
sed  -i "s#PageBlockComponent#PageBlock$COMP_NAME_CAP#g"  $CORTEZA_JS_PATH/src/compose/types/page-block/$COMP_NAME.ts
sed  -i "s#Componentkind#$COMP_NAME_CAP#g"  $CORTEZA_JS_PATH/src/compose/types/page-block/$COMP_NAME.ts

echo "export Compoment.ts in ./corteza-js/src/compose/types/page-block/index.ts"
sed  -i "2i export { PageBlock$COMP_NAME_CAP } from './$COMP_NAME'"  $CORTEZA_JS_PATH/src/compose/types/page-block/index.ts

echo "-------corteza-js---------"

echo "-------corteza-webapp-compose---------"

echo "cpoy selectore_image.png to src/assets/PageBlocks/"
cp $COMP_PATH/selectore_image.png $CORTEZA_COMPOSE_PATH/src/assets/PageBlocks/$COMP_NAME_CAP.png

echo "export selectore_image.png in ./corteza-webapp-compose/src/assets/PageBlocks/index.js"
sed -i "s#// <<<RS_ADD_NEW_COMPOMENT_EXPORT_IMAGE>>>#// <<<RS_ADD_NEW_COMPOMENT_EXPORT_IMAGE>>>\nexport const $COMP_NAME_CAP = require('./$COMP_NAME_CAP.png')#g" $CORTEZA_COMPOSE_PATH/src/assets/PageBlocks/index.js

echo "cpoy Compoment.vue to ./corteza-webapp-compose/src/components/PageBlocks/"
cp $COMP_PATH/Component.vue $CORTEZA_COMPOSE_PATH/src/components/PageBlocks/$COMP_NAME_CAP"Base.vue"
sed -i "s#childCompoments#$COMP_NAME_CAP_COMPONENT#g" $CORTEZA_COMPOSE_PATH/src/components/PageBlocks/$COMP_NAME_CAP"Base.vue"

echo "cpoy ComponentCongiguration.vue to ./corteza-webapp-compose/src/components/PageBlocks/"
cp $COMP_PATH/ComponentCongiguration.vue $CORTEZA_COMPOSE_PATH/src/components/PageBlocks/$COMP_NAME_CAP"Configurator.vue"
sed -i "s#childCompoments#$COMP_NAME_CAP_COMPONENT#g" $CORTEZA_COMPOSE_PATH/src/components/PageBlocks/$COMP_NAME_CAP"Configurator.vue"

echo "cpoy childCompoments to ./corteza-webapp-compose/src/components/PageBlocks/"
mkdir   $CORTEZA_COMPOSE_PATH/src/components/PageBlocks/$COMP_NAME_CAP"Compoments"
cp -R $COMP_PATH/childCompoments/. $CORTEZA_COMPOSE_PATH/src/components/PageBlocks/$COMP_NAME_CAP"Compoments"/.


echo "export MapBase in ./corteza-webapp-compose/src/components/PageBlocks/index.js"
sed -i "s#// <<<RS_ADD_NEW_COMPOMENT_IMPORT_BASE_CONFIGURATOR>>>#// <<<RS_ADD_NEW_COMPOMENT_IMPORT_BASE_CONFIGURATOR>>>\nimport $COMP_NAME_CAP_BASE from './$COMP_NAME_CAP_BASE'#g" $CORTEZA_COMPOSE_PATH/src/components/PageBlocks/index.js

echo "export MapConfigurator in ./corteza-webapp-compose/src/components/PageBlocks/index.js"
sed -i "s#// <<<RS_ADD_NEW_COMPOMENT_IMPORT_BASE_CONFIGURATOR>>>#// <<<RS_ADD_NEW_COMPOMENT_IMPORT_BASE_CONFIGURATOR>>>\nimport $COMP_NAME_CAP_CONFIGURATOR from './$COMP_NAME_CAP_CONFIGURATOR'#g" $CORTEZA_COMPOSE_PATH/src/components/PageBlocks/index.js

echo "export MapBase in ./corteza-webapp-compose/src/components/PageBlocks/index.js"
sed -i "s#  // <<<RS_ADD_NEW_COMPOMENT_ADD_BASE_CONFIGURATOR>>>#  // <<<RS_ADD_NEW_COMPOMENT_ADD_BASE_CONFIGURATOR>>>\n  $COMP_NAME_CAP_BASE,#g" $CORTEZA_COMPOSE_PATH/src/components/PageBlocks/index.js

echo "export MapConfigurator in ./corteza-webapp-compose/src/components/PageBlocks/index.js"
sed -i "s#  // <<<RS_ADD_NEW_COMPOMENT_ADD_BASE_CONFIGURATOR>>>#  // <<<RS_ADD_NEW_COMPOMENT_ADD_BASE_CONFIGURATOR>>>\n  $COMP_NAME_CAP_CONFIGURATOR,#g" $CORTEZA_COMPOSE_PATH/src/components/PageBlocks/index.js

echo "add Map Configuration to ./corteza-webapp-compose/src/components/Admin/Page/Builder/Selector.vue "
sed -i "s#  // <<<RS_ADD_NEW_COMPOMENT_SELECTORE>>>#  // <<<RS_ADD_NEW_COMPOMENT_SELECTORE>>>\n        {\n          label: '$COMP_NAME_CAP',\n          block: new compose.$PAGE_BLOCK_COMP_NAME_CAP(),\n          image: images.$COMP_NAME_CAP,\n        },#g" $CORTEZA_COMPOSE_PATH/src/components/Admin/Page/Builder/Selector.vue




echo "-------corteza-webapp-compose---------"
