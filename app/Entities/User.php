<?php

namespace App\Entities;

use Analogue\ORM\Entity;

class User extends Entity
{
    public function __construct(string $name)
    {
        $this->attributes['name'] = $name;
    }
}
