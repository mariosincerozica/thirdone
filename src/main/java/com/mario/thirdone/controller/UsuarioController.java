package com.mario.thirdone.controller;

import com.mario.thirdone.model.Usuario;
import com.mario.thirdone.service.UsuarioService;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/usuarios")
public class UsuarioController {

    private final UsuarioService service;

    
    public UsuarioController(UsuarioService service) {
        this.service = service;
    }

    @GetMapping
    public List<Usuario> listar() {
    	
        return service.listar();
    }

    @GetMapping("/{id}")
    public Usuario selecionar(@PathVariable Long id) {
        return service.selecionar(id);
    }

    @PostMapping
    public Usuario inserir(@RequestBody Usuario usuario) {
        return service.inserir(usuario);
    }

    @PutMapping("/{id}")
    public Usuario atualizar(@PathVariable Long id, @RequestBody Usuario usuario) {
        return service.atualizar(id, usuario);
    }

    @DeleteMapping("/{id}")
    public void deletar(@PathVariable Long id) {
        service.deletar(id);
    }
}
