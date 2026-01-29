package com.upb.agripos.controller;

import com.upb.agripos.auth.AuthService;
import com.upb.agripos.auth.User;

import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Alert;
import javafx.scene.control.Button;
import javafx.scene.control.PasswordField;
import javafx.scene.control.TextField;
import javafx.stage.Stage;

public class LoginController {
    @FXML private TextField txtUsername;
    @FXML private PasswordField txtPassword;
    @FXML private TextField txtPasswordVisible;
    @FXML private Button btnTogglePassword;
    private AuthService authService = new AuthService();
    private boolean passwordVisible = false;

    @FXML
    public void initialize() {
        // Sinkronkan teks antara password field dan text field
        txtPassword.textProperty().addListener((obs, oldVal, newVal) -> {
            if (!passwordVisible) {
                txtPasswordVisible.setText(newVal);
            }
        });
        txtPasswordVisible.textProperty().addListener((obs, oldVal, newVal) -> {
            if (passwordVisible) {
                txtPassword.setText(newVal);
            }
        });
    }

    @FXML
    public void togglePasswordVisibility() {
        passwordVisible = !passwordVisible;
        if (passwordVisible) {
            txtPasswordVisible.setText(txtPassword.getText());
            txtPasswordVisible.setVisible(true);
            txtPasswordVisible.setManaged(true);
            txtPassword.setVisible(false);
            txtPassword.setManaged(false);
            btnTogglePassword.setText("🙈");
        } else {
            txtPassword.setText(txtPasswordVisible.getText());
            txtPassword.setVisible(true);
            txtPassword.setManaged(true);
            txtPasswordVisible.setVisible(false);
            txtPasswordVisible.setManaged(false);
            btnTogglePassword.setText("👁");
        }
    }

    @FXML
    public void handleLogin() {
        String password = passwordVisible ? txtPasswordVisible.getText() : txtPassword.getText();
        User user = authService.login(txtUsername.getText(), password);

        if (user != null) {
            String fxml = user.getRole().equalsIgnoreCase("ADMIN") ? "/fxml/admin.fxml" : "/fxml/pos.fxml";
            loadScene(fxml, "AgriPOS - " + user.getRole(), user);
        } else {
            new Alert(Alert.AlertType.ERROR, "Login Gagal!").show();
        }
    }

    private void loadScene(String fxml, String title, User user) {
        try {
            FXMLLoader loader = new FXMLLoader(getClass().getResource(fxml));
            Parent root = loader.load();

            // Jika masuk ke POS, kirim data user agar struk tahu nama kasirnya
            if (fxml.equals("/fxml/pos.fxml")) {
                PosController pc = loader.getController();
                pc.setUser(user);
            }

            Stage stage = (Stage) txtUsername.getScene().getWindow();
            stage.setScene(new Scene(root));
            stage.setTitle(title);
            stage.show();
        } catch (Exception e) { e.printStackTrace(); }
    }
}