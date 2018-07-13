package student;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import operations.*;
import tests.TestHandler;
import tests.TestRunner;

public class StudentMain {

    public static void main(String[] args) {
        
        //initDB();

        CityOperations cityOperations = new ja140600_City();
        DistrictOperations districtOperations = new ja140600_District();
        CourierOperations courierOperations = new ja140600_Courier();
        CourierRequestOperation courierRequestOperation = new ja140600_CourierRequest();
        GeneralOperations generalOperations = new ja140600_General();
        UserOperations userOperations = new ja140600_User();
        VehicleOperations vehicleOperations = new ja140600_Vehicle();
        PackageOperations packageOperations = new ja140600_Package();

        generalOperations.eraseAll();

        TestHandler.createInstance(
                cityOperations,
                courierOperations,
                courierRequestOperation,
                districtOperations,
                generalOperations,
                userOperations,
                vehicleOperations,
                packageOperations);

        TestRunner.runTests();

    }

    private static boolean initDB() {
        Connection conn = DB.getConnection();

        Integer[] fuelIDs = new Integer[]{0, 1, 2};
        Double[] fuelPrices = new Double[]{15.0, 36.0, 32.0};

        Integer[] packageInfoIDs = new Integer[]{0, 1, 2};
        Double[] packageInfoInitialPrice = new Double[]{10.0, 25.0, 75.0};
        Double[] packageInfoWeightFactor = new Double[]{0.0, 1.0, 2.0};
        Double[] packageInfoPricePerKG = new Double[]{1.0, 100.0, 300.0};

        try (PreparedStatement stmt = conn.prepareCall("insert into Fuel(IdFuel, Price) values (?, ?)")) {
            for (int i = 0; i < fuelIDs.length; i++) {
                stmt.setInt(1, fuelIDs[i]);
                stmt.setDouble(2, fuelPrices[i]);

                if (stmt.executeUpdate() != 1) {
                    return false;
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        try (PreparedStatement stmt = conn.prepareCall("insert into PackageInfo(IdPackageInfo, InitialPrice, WeightFactor, Price) values (?,?,?,?)")) {
            for (int i = 0; i < packageInfoIDs.length; i++) {
                stmt.setInt(1, packageInfoIDs[i]);
                stmt.setDouble(2, packageInfoInitialPrice[i]);
                stmt.setDouble(3, packageInfoWeightFactor[i]);
                stmt.setDouble(4, packageInfoPricePerKG[i]);

                if (stmt.executeUpdate() != 1) {
                    return false;
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return true;
    }

}
