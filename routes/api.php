<?php

use App\Http\Controllers\Api\UserActivityController;
use Illuminate\Support\Facades\Route;

Route::middleware('auth:sanctum')
    ->get('user', fn (Request $request) => $request->user());

Route::post('user-activities', [UserActivityController::class, 'store'])
    ->middleware('throttle:120,1')
    ->name('api.user-activities.store');
