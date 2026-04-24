<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::get('/home', function(){
    return 'Page home';
});

Route::get('/shop', function(){
    return 'Page shop';
});

Route::get('/about', function(){
    return 'Page about';
});

Route::get('/contact', function(){
    return 'Page contact';
});