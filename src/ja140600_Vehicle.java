package student;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;
import operations.VehicleOperations;

public class ja140600_Vehicle implements VehicleOperations {

    @Override
    public boolean insertVehicle(String licenceNumber, int fuelType, BigDecimal fuelConsumption) {
        
        Connection conn = DB.getConnection();
        
        try (PreparedStatement stmt = conn.prepareStatement("insert into Vehicle(LicenceNumber, FuelEfficiency, IdFuel) values (?, ?, ?)")) {
            stmt.setString(1, licenceNumber);
            stmt.setDouble(2, fuelConsumption.doubleValue());
            stmt.setInt(3, fuelType);
            
            if (stmt.executeUpdate() == 1) {
                return true;
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }
        
        return false;
    }

    @Override
    public int deleteVehicles(String... licencePlateNumbers) {
        
        Connection conn = DB.getConnection();
        
        StringBuilder builder = new StringBuilder();
        
        for (int i=0;i<licencePlateNumbers.length;i++){
            builder.append("?,");
        }
        
        builder.deleteCharAt(builder.length() -1);
        
        try (PreparedStatement stmt = conn.prepareStatement("delete from Vehicle where LicenceNumber in (" + builder.toString()+")")) {
            for (int i =0;i<licencePlateNumbers.length;i++){
                stmt.setString(i+1, licencePlateNumbers[i]);
            }
            
            return stmt.executeUpdate();
            
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }
        
        return 0;
        
    }

    @Override
    public List<String> getAllVehichles() {
        List<String> list = new LinkedList<>();
        
        Connection conn = DB.getConnection();
        
        try (PreparedStatement stmt = conn.prepareStatement("select LicenceNumber from Vehicle"); ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()){
                list.add(rs.getString(1));
            }
            
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }
        
        return list;
    }

    @Override
    public boolean changeFuelType(String licensePlateNumber, int fuelType) {
        
        Connection conn = DB.getConnection();
        
        try (PreparedStatement stmt = conn.prepareStatement("update Vehicle set IdFuel = ? where LicenceNumber = ?")) {
            stmt.setInt(1, fuelType);
            stmt.setString(2, licensePlateNumber);
            
            if (stmt.executeUpdate() == 1){
                return true;
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }
        return false;
    }

    @Override
    public boolean changeConsumption(String licensePlateNumber, BigDecimal fuelConsumption) {
        
        Connection conn = DB.getConnection();
        
        try (PreparedStatement stmt = conn.prepareStatement("update Vehicle set FuelEfficiency = ? where LicenceNumber = ?")) {
            stmt.setDouble(1, fuelConsumption.doubleValue());
            stmt.setString(2, licensePlateNumber);
            
            if (stmt.executeUpdate() == 1){
                return true;
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }
        return false;
    }
    
    

}
