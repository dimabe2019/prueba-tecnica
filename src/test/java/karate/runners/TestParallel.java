package karate.runners;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import karate.utils.Constantes;
import org.junit.jupiter.api.Test;

import static karate.utils.Constantes.*;
import static karate.utils.GenerateReport.generateReport;
import static org.junit.jupiter.api.Assertions.assertEquals;

public class TestParallel {

    @Test
    public void testParallel() {
        Results results = Runner.path(CLASS_PATH_KARATE).outputCucumberJson(TRUE).tags(IGNORE).parallel(ONE);
        generateReport(results.getReportDir());
        assertEquals(ZERO, results.getFailCount(), results.getErrorMessages());
    }
}
