package com.ippon.cilium.handson.unit.clients;

import com.ippon.cilium.handson.unit.models.Weapon;
import retrofit2.Call;
import retrofit2.http.GET;

public interface Stronghold {

  @GET("/weapons")
  Call<Weapon> getWeapon();
}
