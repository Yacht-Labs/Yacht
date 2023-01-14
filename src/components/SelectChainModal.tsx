import React from "react";
import { View, StyleSheet, Text, Modal, TouchableOpacity, FlatList } from "react-native";
import { AVAILABLE_CHAINS } from "../constants";

export default function SelectChainModal({ style, modalVisible, onRequestClose, onPressSpecificChain }) {
    
    return (
        <View style={[style, styles.mainContainer]}>
            <Modal
                animationType="slide"
                transparent={true}
                visible={modalVisible}
                onRequestClose={onRequestClose}
            >
                
                    <View style={styles.modalView}>
                        <FlatList
                            data={AVAILABLE_CHAINS}
                            renderItem={({item}) => <Item title={item.label} symbol={item.symbol} onPressSpecificChain={onPressSpecificChain} litChainId={item.litChainId} />}
                            keyExtractor={item => item.chainId}
                        />
                    </View>
                
            </Modal>
        </View>
    );
};

const Item = ({title, symbol, litChainId, onPressSpecificChain}) => (
    <TouchableOpacity 
    onPress={() => onPressSpecificChain(litChainId)} 
    activeOpacity={0.8} >
        <View style={styles.item}>
            <Text style={styles.title}>{title}</Text>
            <Text style={styles.symbol}>{symbol}</Text>
        </View>
    </TouchableOpacity>
  );
  

const styles = StyleSheet.create({
    mainContainer: {
        flex: 1,
    },
    modalView: {
        flex: 1,
        backgroundColor: 'white',
        marginTop: 400,
        borderRadius: 30,
        shadowRadius: 2,
        shadowOpacity: .2,
        shadowColor: 'grey',
    },
    label: {
        marginTop: 30,
        color: 'white',
        fontSize: 40,
        textAlign: 'center'
    },
    item: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        paddingHorizontal: 20,
        paddingTop: 22,
    },
    title: {
        flex: 1,
        fontFamily: 'Akkurat',
        fontSize: 18,
    },
    symbol: {
        flex: 1,
        fontFamily: 'Akkurat-Bold',
        fontSize: 16,
        textAlign: 'right'
    }
});

