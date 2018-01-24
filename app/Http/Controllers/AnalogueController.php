<?php

namespace App\Http\Controllers;

use App\Entities\User;
use Analogue\ORM\AnalogueFacade as Analogue;

class AnalogueController extends Controller
{
    public function example()
    {
        $userMapper = Analogue::mapper(User::class);
        $user = new User('John');
        $userMapper->store($user);
    }
}
