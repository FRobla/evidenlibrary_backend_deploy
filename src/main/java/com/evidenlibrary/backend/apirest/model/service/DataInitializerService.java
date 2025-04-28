package com.evidenlibrary.backend.apirest.model.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.evidenlibrary.backend.apirest.model.dao.AutorDao;
import com.evidenlibrary.backend.apirest.model.dao.GeneroDao;
import com.evidenlibrary.backend.apirest.model.dao.LibroDao;
import com.evidenlibrary.backend.apirest.model.entity.Autor;
import com.evidenlibrary.backend.apirest.model.entity.Genero;
import com.evidenlibrary.backend.apirest.model.entity.Libro;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

/**
 * Servicio encargado de asegurar que las relaciones entre entidades se inicialicen correctamente
 * Este servicio se ejecuta después de que Spring Boot ha cargado los datos de data.sql
 */
@Service
public class DataInitializerService implements CommandLineRunner {

    @Autowired
    private LibroDao libroDao;
    
    @Autowired
    private AutorDao autorDao;
    
    @Autowired
    private GeneroDao generoDao;
    
    @PersistenceContext
    private EntityManager entityManager;
    
    @Override
    @Transactional
    public void run(String... args) throws Exception {
        // Limpiar la caché de Hibernate para asegurar que todas las entidades se refresquen
        entityManager.clear();
        
        // Recargar todas las entidades y sus relaciones
        List<Libro> libros = libroDao.findAll();
        List<Autor> autores = autorDao.findAll();
        List<Genero> generos = generoDao.findAll();
        
        System.out.println("Inicializando relaciones de entidades...");
        System.out.println("Libros encontrados: " + libros.size());
        System.out.println("Autores encontrados: " + autores.size());
        System.out.println("Géneros encontrados: " + generos.size());
        
        // Inicialización explícita de las relaciones entre libros y autores
        for (Libro libro : libros) {
            for (Autor autor : libro.getAutores()) {
                if (!autor.getLibros().contains(libro)) {
                    autor.getLibros().add(libro);
                }
            }
            
            for (Genero genero : libro.getGeneros()) {
                if (!genero.getLibros().contains(libro)) {
                    genero.getLibros().add(libro);
                }
            }
            
            // Recalcular valoración media si es necesario
            if (libro.getValoraciones() != null && !libro.getValoraciones().isEmpty()) {
                libro.getValoracionMedia();
            }
        }
        
        // Guardar los cambios en la base de datos
        libroDao.saveAll(libros);
        autorDao.saveAll(autores);
        generoDao.saveAll(generos);
        
        System.out.println("Inicialización de relaciones completada.");
    }
} 