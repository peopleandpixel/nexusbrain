# Flutter rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Isar rules
-keep class io.isar.** { *; }
-keep interface io.isar.** { *; }
-keep enum io.isar.** { *; }
-keep class * extends io.isar.** { *; }
-keep @io.isar.annotation.Collection class * { *; }
-keep @io.isar.annotation.Id class * { *; }
-keep @io.isar.annotation.Index class * { *; }
-keep @io.isar.annotation.Size class * { *; }
-keep @io.isar.annotation.Type class * { *; }
-keep @io.isar.annotation.Name class * { *; }
-keep @io.isar.annotation.Ignore class * { *; }
-keep @io.isar.annotation.Converter class * { *; }

# SQLite rules
-keep class org.sqlite.** { *; }

# General rules
-dontwarn io.flutter.embedding.android.FlutterActivity
-dontwarn io.flutter.embedding.android.FlutterFragment
-dontwarn io.flutter.embedding.android.FlutterView

# Play Core (Deferred Components)
-dontwarn com.google.android.play.core.**
