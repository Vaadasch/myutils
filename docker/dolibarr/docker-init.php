#!/usr/bin/env php
<?php

while (ob_get_level()) {
    ob_end_flush();
}

require_once '../htdocs/master.inc.php';
require_once DOL_DOCUMENT_ROOT.'/core/lib/admin.lib.php';
printf("Activating module User... ");
activateModule('modUser');
printf("OK\n");

if (!empty(getenv('DOLI_ENABLE_MODULES'))) {
  $dirMods = array_keys(dolGetModulesDirs())[0];

  $mods = explode(',', getenv('DOLI_ENABLE_MODULES'));
  foreach ($mods as $mod) {
    $modName = 'mod'.$mod;
    $modFile = $modName.'.class.php';
    if (file_exists($dirMods.$modFile) ) {
      printf("Activating module ".$mod." ...");
      activateModule('mod' . $mod);
      printf(" Ok\n");
    }
    else {
      printf("Unable to find module : ".$modName."\n");
    }
  }
}

require_once DOL_DOCUMENT_ROOT.'/core/lib/company.lib.php';
$s = '1:FR:France';
dolibarr_set_const($db, "MAIN_INFO_SOCIETE_COUNTRY", $s, 'chaine', 0, '', $conf->entity);
activateModulesRequiredByCountry('FR');

if (!empty(getenv('COMPANY_NAME'))) {
        $compname = getenv('COMPANY_NAME');
        dolibarr_set_const($db, "MAIN_INFO_SOCIETE_NOM", "Wouafwouf", 'chaine', 0, '', $conf->entity);
}

$db->commit();
