import React from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import CreateLitSwapView from '../views/CreateLitSwapView';
import SendTokensToSwap from '../views/SendTokensToSwap';

const Stack = createNativeStackNavigator();

export default function LitSwapNavigator() {
    return(
        <NavigationContainer>
            <Stack.Navigator
                screenOptions={{
                    headerLargeTitle: true,
                    headerLargeTitleStyle: {
                        fontFamily: 'Bookmania',
                        fontSize: 28
                    },
                    contentStyle: {
                        backgroundColor: 'white'
                    },
                    headerTransparent: true
            }}>
                <Stack.Screen name="New Lit Yacht Swap" component={CreateLitSwapView} />
                <Stack.Screen name="Send Tokens To Swap" component={SendTokensToSwap} />
            </Stack.Navigator>
        </NavigationContainer>
    );
};