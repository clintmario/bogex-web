<?php
/**
 * Created by PhpStorm.
 * User: ClintMario
 * Date: 9/5/2016
 * Time: 1:47 PM
 */

Route::get('/', function () {
    return View('Fortuna::home', ['sections' => ['home', 'services', 'clients', 'portfolio', 'testimonials', 'about', 'contact']]);
});