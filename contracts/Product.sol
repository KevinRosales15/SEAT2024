// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Tienda {

    enum Estado {Activado, Desactivado, Preventa} // valores numericos

    mapping (uint => Producto) public productos;

    struct Producto
    {
    string nombre;
    uint cantidad;
    Estado estado;
    address payable creador;
    }

    function comprar(uint _id) public payable esCliente (_id) productoValido(_id)
    {
        require(
            msg.value > 0,
            "Debe de transferir un valor minimo"
        );
        productos[_id].creador.transfer(msg.value);
        productos[_id].cantidad --;
    }

    modifier esCreador(uint _id)
     {
        require(
            msg.sender == productos[_id].creador,
            "Debe de ser un creador para ejecutar esta accion"
        );
        _;
    }

     modifier esCliente (uint _id)
     {
        require(
            msg.sender != productos[_id].creador,
            "Debe de ser un cliente para ejecutar esta accion"
        );
        _;
    }
    
    modifier productoValido(uint _id)
    {
        require(
            productos[_id].estado != Estado.Desactivado,
            "El producto debe estar activado"
        );
        require(
            productos[_id].cantidad > 0,
            "El producto debe de tener existencias"
        );
        _;
    }
    
    modifier productoDesactivado (uint _id)
    {
        require(
            productos[_id].estado == Estado.Desactivado,
            "El producto debe estar desactivado"
        );
        _;
    }

    function cambiarestado (uint _id, Estado nuevoEstado) public esCreador(_id) 
    {
        productos[_id].estado = nuevoEstado;
    }

    function crearProducto (uint _id, string memory _nombre, Estado _estado, uint _cantidad) public 
    {
        productos [_id] = Producto(_nombre, _cantidad, _estado, payable (msg.sender));
    }

   

    
}