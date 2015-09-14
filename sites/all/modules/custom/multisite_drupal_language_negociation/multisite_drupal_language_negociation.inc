<?php
/**
 * @file
 * multisite_drupal_language negociation.inc
 */

define('LOCALE_LANGUAGE_NEGOTIATION_URL_SUFFIX', 'locale-url-suffix');
/**
  * callback functions for the multisite language negotiation providers, module : multisite_drupal_language_negociation
  */
function multisite_language_provider_callback($languages) {
  $language_url = FALSE;
  if (!language_negotiation_get_any(LOCALE_LANGUAGE_NEGOTIATION_URL_SUFFIX)) {
    return $language_url;
  }

  // $_GET['q'] might not be available at this time, because
  // path initialization runs after the language bootstrap phase.
  list($language, $_GET['q']) = language_url_split_suffix(isset($_GET['q']) ? $_GET['q'] : NULL, $languages);
  if ($language !== FALSE) {
    $language_url = $language->language;
  }

  return $language_url;
}



function multisite_url_rewrite_callback(&$path, &$options) {
  global $language;
  $delimiter = variable_get('language_suffix_delimiter', '_');

  $language_list = language_list('enabled');
  $languages = array_flip(array_keys($language_list[1]));

  // Language can be passed as an option, or we go for current URL language.
  if (!isset($options['language'])) {
    if(isset($options['attributes']['lang'])) {
      $options['language'] = $language_list[1][$options['attributes']['lang']];
    }
    else {
      global $language_url;
        $options['language'] = $language_url;
    }
  }
  // We allow only enabled languages here.
  elseif (!isset($languages[$options['language']->language])) {
    unset($options['language']);
    return;
  }

  $path = drupal_get_path_alias(empty($path)?variable_get('site_frontpage', 'node'):$path, $options['language']->language);

  if ($path == '<front>' || $path == '') { // handle the homepage url
    $path = variable_get('site_frontpage', 'node');
  }

  $path .= $delimiter.$options['language']->prefix;

  $options['alias'] = TRUE;
}



/*
 * extract the suffix from the path
 */
function language_url_split_suffix($path, $languages) {
  $delimiter = variable_get('language_suffix_delimiter', '_');
  $args = empty($path) ? array() : explode($delimiter, $path);
  $suffix = array_pop($args);
  // handle if there are extra parameters after the suffix
  $extra_params = explode("/", $suffix);
  $suffix = array_shift($extra_params);

  // Search prefix within enabled languages.
  foreach ($languages as $language) {
    if (!empty($language->prefix) && $language->prefix == $suffix) {
      // Rebuild $path with the language removed.
      $path = implode($delimiter, $args);
      $path = ($path == 'index')?'': $path; // handle the path homepage
      // add extra params after suffix
      if (count($extra_params) > 0) {
        $path .= "/" . implode("/", $extra_params);
      }
      return array($language, $path);
    }
  }
  return array(FALSE, $path);
}


function multisite_language_switcher_url($type, $path) {
  $languages = language_list('enabled');
  $links = array();
  foreach ($languages[1] as $language) {
    $links[$language->language] = array(
      'href' => $path,
      'title' => $language->native,
      'language' => $language,
      'attributes' => array('class' => array('language-link')),
    );
  }
  return $links;
}
