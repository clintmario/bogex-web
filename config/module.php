<?php
/**
 * Created by PhpStorm.
 * User: ClintMario
 * Date: 9/5/2016
 * Time: 1:25 PM
 */
return [
    'modules' => [
        'Theme',
        'Home',
    ],
    'app_segment' => preg_replace("/https?:\/\/(.*$)/i", "$1", config('app.url')),
];