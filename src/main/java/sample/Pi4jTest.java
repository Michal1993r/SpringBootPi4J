package sample;

import com.pi4j.io.serial.*;
import org.springframework.stereotype.Service;

/**
 * Created by pi on 12.11.16.
 */
@Service
public class Pi4jTest {

    private com.pi4j.io.serial.Serial bluetooth;
    private SerialConfig serialConfig;

    public Pi4jTest() {
        bluetooth = SerialFactory.createInstance();
        bluetooth.addListener((SerialDataEventListener) serialDataEvent -> {


        });
        try {
            serialConfig = new SerialConfig();
            serialConfig.device(SerialPort.getDefaultPort())
                    .baud(Baud._115200)
            .dataBits(DataBits._8)
            .parity(Parity.NONE)
            .stopBits(StopBits._1);
            bluetooth.open(serialConfig);
        } catch(Exception e){
            e.printStackTrace();
        }
    }

    public com.pi4j.io.serial.Serial getBluetooth() {
        return bluetooth;
    }

    public void setBluetooth(com.pi4j.io.serial.Serial bluetooth) {
        this.bluetooth = bluetooth;
    }
}
