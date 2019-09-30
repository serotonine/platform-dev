<?php

/**
 * @file
 * Hooks and callbacks used by rules api.
 */

/**
 * Implements hook_rules_action_info().
 */
function nexteuropa_varnish_rules_action_info() {
  return array(
    'nexteuropa_varnish_rules_action_flush' => array(
      'label' => t('Varnish flush'),
      'group' => t('Entity'),
      'parameter' => array(
        'entity' => array(
          'type' => 'entity',
          'label' => t("Entity"),
        ),
        'string' => array(
          'type' => 'text',
          'label' => t('Regexp'),
          'description' => t('Enter a value for a string that will be hashed using the md5 hash-algorithm.'),
        ),
      ),
    ),
  );
}

/**
 * Callback for rules action.
 *
 * @param object $wrapper
 *   Entity wrapper passed argument.
 * @param string $string
 *   Regexp string argument.
 */
function nexteuropa_varnish_rules_action_flush($wrapper, $string) {
  $type = $wrapper->type();
  $entity = $wrapper->value();
  $info = $wrapper->getPropertyInfo();
  $item = FALSE;
  
  foreach ($info as $key => $field) {
    $definition = field_info_field($key);

    if ($definition['type'] == 'entityreference' || $definition['type'] == 'taxonomy_term_reference') {
      foreach ($wrapper->{$key} as $item) {
        // dpm($item->value());
        // TODO: check and clear paths here.
      }
    }
  }

  switch ($type) {
    case 'node':
      $updated_node_paths = _nexteuropa_varnish_get_updated_node_paths($entity);
      _nexteuropa_varnish_process_paths_sending($entity, $updated_node_paths);
      break;

    case 'file':
      // _nexteuropa_varnish_flush_file($entity);
      break;
  }

  module_load_include('inc', 'nexteuropa_varnish', 'nexteuropa_varnish.rules.admin');
  $regex = _nexteuropa_varnish_gather_expressions($string);
  _nexteuropa_varnish_purge_paths(array($regex));
}
