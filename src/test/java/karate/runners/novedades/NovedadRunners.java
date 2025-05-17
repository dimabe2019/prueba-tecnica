package karate.runners.novedades;

import com.intuit.karate.junit5.Karate;

import static karate.utils.Constantes.NOVEDADES;

public class NovedadRunners {
    @Karate.Test
    Karate novedad() {
        return Karate.run(NOVEDADES).relativeTo(getClass());
        //return Karate.run(NOVEDADES).tags("@DetalleNovedad").relativeTo(getClass());
    }
}
