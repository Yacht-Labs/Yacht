import React from "react";
import { View, StyleSheet, Text, TouchableOpacity } from "react-native";

export default function YachtButton({ onPress, title, style }) {
    return (
        <TouchableOpacity 
            onPress={onPress} 
            activeOpacity={0.8} >
            <View style={[style, styles.buttonContainer]}>
                <Text style={styles.buttonText}>{title}</Text>
            </View>
        </TouchableOpacity>
    );
}

const styles = StyleSheet.create({
    buttonText: {
        fontFamily: 'Akkurat-Bold',
        fontSize: 18,
        color: 'white',
        textAlign: 'center'
    },
    buttonContainer: {
        justifyContent: 'center',
        elevation: 8,
        borderRadius: 10,
        paddingVertical: 10,
        paddingHorizontal: 12
      },
});