package student;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import operations.GeneralOperations;

public class ja140600_General implements GeneralOperations {

    @Override
    public void eraseAll() {
        Connection conn = DB.getConnection();
        String ops[] = {
            "delete from Package where 1=1",
            "delete from District where 1=1",
            "delete from City where 1=1",
            "delete from Courier where 1=1",
            "delete from Request where 1=1",
            "delete from MyUser where 1=1",
            "delete from Vehicle where 1=1"};

        for (String op : ops) {
            try (PreparedStatement stmt = conn.prepareStatement(op)) {
                stmt.executeUpdate();
            } catch (SQLException ex) {
                ex.printStackTrace(System.out);
            }
        }
    }

}
