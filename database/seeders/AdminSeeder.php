<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class AdminSeeder extends Seeder
{
    public function run(): void
    {
        $users = [
            [
                'name' => 'Amrull',
                'email' => 'amrull@telkomakses.co.id',
                'no_hp' => '087862484803',
                'password' => 'pass123'
            ],
            [
                'name' => 'Widya',
                'email' => 'widya@telkomakses.co.id',
                'no_hp' => '082222222222',
                'password' => 'pass123'
            ],
            [
                'name' => 'Rahmi',
                'email' => 'rahmi@telkomakses.co.id',
                'no_hp' => '083333333333',
                'password' => 'pass123'
            ],
            [
                'name' => 'Ikak',
                'email' => 'ika@telkomakses.co.id',
                'no_hp' => '084444444444',
                'password' => 'pass123'
            ],
            [
                'name' => 'Nike',
                'email' => 'nike@telkomakses.co.id',
                'no_hp' => '085555555555',
                'password' => 'pass123'
            ],
            [
                'name' => 'Direktur',
                'email' => 'direktur@telkomakses.co.id',
                'no_hp' => '086666666666',
                'password' => 'pass123'
            ],
        ];

        foreach ($users as $user) {
            User::updateOrCreate(
                ['email' => $user['email']],
                [
                    'name' => $user['name'],
                    'no_hp' => $user['no_hp'],
                    'password' => Hash::make($user['password']),
                ]
            );
        }
    }
}