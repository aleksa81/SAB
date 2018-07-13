package student;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import operations.CityOperations;

public class ja140600_City implements CityOperations {

    @Override
    public int insertCity(String name, String postalCode) {

        Connection conn = DB.getConnection();
        try (PreparedStatement stmt = conn.prepareStatement("insert into City(Name, PostalCode) values (?,?)",
                Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, name);
            stmt.setString(2, postalCode);

            if (stmt.executeUpdate() == 0) {
                return -1;
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return (int) generatedKeys.getLong(1);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }

        return -1;
    }

    @Override
    public int deleteCity(String... names) {

        Connection conn = DB.getConnection();

        StringBuilder builder = new StringBuilder();

        for (int i = 0; i < names.length; i++) {
            builder.append("?,");
        }
        
        builder.deleteCharAt(builder.length() - 1);

        try (PreparedStatement stmt = conn.prepareStatement("delete from City where Name in (" + builder.toString() + ")")) {
            for (int i = 0; i < names.length; i++) {
                stmt.setString(i + 1, names[i]);
            }
            return stmt.executeUpdate();

        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }

        return -1;
    }

    @Override
    public boolean deleteCity(int idCity) {

        Connection conn = DB.getConnection();
        
        try (PreparedStatement stmt = conn.prepareStatement("delete from City where IdCity = ?")) {
            stmt.setInt(1, idCity);

            if (stmt.executeUpdate() == 1) {
                return true;
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }

        return false;
    }

    @Override
    public List<Integer> getAllCities() {
        List<Integer> list = new ArrayList<>();

        Connection conn = DB.getConnection();
        
        try (PreparedStatement stmt = conn.prepareStatement("select IdCity from City"); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(rs.getInt("IdCity"));
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }

        return list;
    }
}
