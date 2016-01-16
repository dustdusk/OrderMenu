package dao;

import org.springframework.data.jpa.repository.JpaRepository;

import entity.MenuItem;

public interface MenuItemDao extends JpaRepository<MenuItem, Integer> {

}
