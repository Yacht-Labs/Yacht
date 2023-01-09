import React from "react";
import { View, StyleSheet, Text, TouchableOpacity } from "react-native";

export default function YachtButton({ onPress, title, type }) {
    let bc;
    if (type == 'info') {
        bc = '#736356';
    } else if (type == 'action') {
        bc = '#AD1D1D';
    }
    return (
        <View style={[{ backgroundColor: bc }, styles.buttonContainer]}>
        <TouchableOpacity 
            onPress={onPress} 
            activeOpacity={0.8} >
            <Text style={styles.buttonText}>{title}</Text>
        </TouchableOpacity>
        </View>
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
        flex: 1,
        justifyContent: 'center',
        elevation: 8,
        borderRadius: 10,
        paddingVertical: 10,
        paddingHorizontal: 12
      },
});