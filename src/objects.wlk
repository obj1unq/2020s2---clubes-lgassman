
class Club {
	const property socios = #{}
	const property actividades = #{}

	method agregarSocio(_socio) {
		socios.add(_socio)
	}
	
	method desasociar(_socio) {
		socios.remove(_socio)
	}	
	
	method agregarActividad(actividad) {
		actividades.add(actividad)
	}
	
	method pertenece(_socio) {
		return socios.contains(_socio)
	}
	
	override method initialize() {
		clubes.agregar(self)
	}
	
	method socioMasAntiguo() {
		return socios.max({socio => socio.antiguedad()})	
	}
	
	method sociosDestacados() {
		//return socios.filter({socio => socio.esDetacado() })
		return actividades.map({actividad => actividad.socioDestacado()}).asSet()
	}
	
	method esDestacado(socio) {
		return actividades.any({actividad => actividad.socioDestacado() == socio})
	} 
	
	method esEstrella(jugador) {
		return self.esMuyActivo(jugador)
	} 
	
	method esMuyActivo(jugador) {
		return actividades.count({actividad => actividad.participa(jugador)}) >= 3
	}
}

object paseEstrella {
	var property valor = 1000
}

class ClubProfesional inherits Club {
	
	override method esEstrella(jugador)  {
		return	jugador.esCaro()
	}
	
}

//class ClubComunitario inherits Club {
//	
////	override method esEstrella(jugador)  {
////		return	self.esMuyActivo(jugador)
////	}	
//}

class ClubTradicional inherits Club {
	override method esEstrella(jugador)  {
		return	jugador.esCaro() or super(jugador)
	}	
}

object clubes {
	
	const clubes = #{}
	
	method clubDe(socio) {
		return clubes.find({club => club.pertenece(socio)})
	}
	
	method agregar(club) {
		clubes.add(club)
	}
}

class Socio {
	var property antiguedad = 0
	
	method club() {
		return clubes.clubDe(self)	
	}	
	
	method esDetacado() {
		return self.club().esDestacado(self)	
	}

	method esEstrella() 
	
}

class SocioComun inherits Socio {
	
	override method esEstrella() {
		return antiguedad > 20
	}
}

class Jugador inherits Socio {
	var property partidos = 0
	var property pase = 10
	
	override method esEstrella() {
		return partidos >= 50 or self.club().esEstrella(self)
	}
	
	method esCaro() {
		return self.pase() > paseEstrella.valor()
	}
}

class Actividad {
	const property integrantes = #{}
	const property socioDestacado
	
	method agregar(socio) {
		integrantes.add(socio)
	}
	
	method participa(socio) {
		return integrantes.contains(socio)
	}
}




