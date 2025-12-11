<?php

declare(strict_types=1);

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;

class UserSeeder extends Seeder
{
    public function run(): void
    {
        User::factory()
            ->withAvatar()
            ->withAdminRole()
            ->withoutTwoFactor()
            ->create(['email' => 'admin@example.com']);

        User::factory()
            ->withAvatar()
            ->withManagerRole()
            ->withoutTwoFactor()
            ->create(['email' => 'manager@example.com']);

        User::factory()
            ->withAvatar()
            ->withBaseRoles()
            ->withoutTwoFactor()
            ->create(['email' => 'user@example.com']);

        User::factory(5)
            ->withAvatar()
            ->withBaseRoles()
            ->withoutTwoFactor()
            ->create();
    }
}
