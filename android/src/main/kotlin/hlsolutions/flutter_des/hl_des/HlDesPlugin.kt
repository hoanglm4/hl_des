package hlsolutions.flutter_des.hl_des

import android.util.Base64
import android.util.Log
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.nio.charset.StandardCharsets
import java.security.spec.KeySpec
import javax.crypto.Cipher
import javax.crypto.SecretKeyFactory
import javax.crypto.spec.DESKeySpec
import javax.crypto.spec.IvParameterSpec

/** HlDesPlugin */
class HlDesPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "hl_des")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        val params = call.arguments as HashMap<*, *>
        val key = params["key"] as String
        val iv = params["iv"] as String
        val data = params["data"] as String
        when (call.method) {
            "desEncrypt" -> result.success(decrypt(data, key, iv))
            "desDecrypt" -> result.success(encrypt(data, key, iv))
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun encrypt(plainText: String, sBase64CryptKey: String, sBase64IV: String): String {
        var sResult: String = plainText
        try {
            // Get CryptKey.
            val btCryptKey: ByteArray = Base64.decode(sBase64CryptKey, Base64.DEFAULT)
            val sCryptKey = String(btCryptKey, StandardCharsets.UTF_8)
            // Get IV.
            val btInitializationVector: ByteArray = Base64.decode(sBase64IV, Base64.DEFAULT)
            // Encrypt
            val keySpec: KeySpec = DESKeySpec(sCryptKey.toByteArray(charset("ASCII")))
            val key = SecretKeyFactory.getInstance("DES").generateSecret(keySpec)
            val iv = IvParameterSpec(btInitializationVector)
            val cipher = Cipher.getInstance("DES/CBC/PKCS7Padding")
            cipher.init(Cipher.ENCRYPT_MODE, key, iv)
            val btEncoded = cipher.doFinal(plainText.toByteArray(charset("ASCII")))
            sResult = Base64.encodeToString(btEncoded, Base64.DEFAULT)
        } catch (e: Exception) {
            Log.e("HlDesPlugin", "encrypt exception", e)
        }
        return sResult
    }

    private fun decrypt(plainText: String, sBase64CryptKey: String, sBase64IV: String): String {
        var sResult: String = plainText
        try {
            // Get CryptKey.
            val btCryptKey = Base64.decode(sBase64CryptKey, Base64.DEFAULT)
            val sCryptKey = String(btCryptKey, StandardCharsets.UTF_8)
            // Get IV.
            val btInitializationVector = Base64.decode(sBase64IV, Base64.DEFAULT)
            // Encrypt
            val keySpec: KeySpec = DESKeySpec(sCryptKey.toByteArray(charset("ASCII")))
            val key = SecretKeyFactory.getInstance("DES").generateSecret(keySpec)
            val iv = IvParameterSpec(btInitializationVector)
            val cipher = Cipher.getInstance("DES/CBC/PKCS7Padding")
            cipher.init(Cipher.ENCRYPT_MODE, key, iv)
            // Decrypt
            cipher.init(Cipher.DECRYPT_MODE, key, iv)
            val btDecoded = cipher.doFinal(Base64.decode(plainText, Base64.DEFAULT))
            sResult = String(btDecoded)
        } catch (e: java.lang.Exception) {
            Log.e("HlDesPlugin", "decrypt exception", e)
        }
        return sResult
    }
}
