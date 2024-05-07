package com.ippon.cilium.handson.stronghold.models;

import java.util.Random;

public enum Weapon {
  SUPER_SWORD, BLOOD_AXE, MAGICAL_STAFF;

  private static final Random PRNG = new Random();

  public static Weapon randomWeapon()  {
    Weapon[] weapons = values();
    return weapons[PRNG.nextInt(weapons.length)];
  }
}
