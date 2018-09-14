/** 
 * Copyright (c) 2018 committers of YAKINDU and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 * Contributors:
 * Andreas Muelder - Itemis AG - initial API and implementation
 * Karsten Thoms   - Itemis AG - initial API and implementation
 * Florian Antony  - Itemis AG - initial API and implementation
 * committers of YAKINDU 
 */
package com.yakindu.solidity.typesystem.builtin

import com.google.inject.Inject
import com.google.inject.Singleton
import com.yakindu.solidity.solidity.PragmaDirective
import com.yakindu.solidity.solidity.SolidityFactory
import com.yakindu.solidity.solidity.SourceUnit
import com.yakindu.solidity.typesystem.SolidityTypeSystem
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.EcoreUtil2
import org.yakindu.base.types.Operation
import org.yakindu.base.types.Property
import org.yakindu.base.types.TypesFactory
import org.yakindu.base.types.typesystem.ITypeSystem

/** 
 * @author Florian Antony - Initial contribution and API
 */
@Singleton 
class BuiltInDeclarationsFactory implements IBuiltInDeclarationsFactory{
	public static final String DEFAULT_SOLIDITY_VERSION="^0.4.23"
	public static final String ZERO_FIVE_ZERO="^0.5.0"
	@Inject ITypeSystem typeSystem
	@Inject TypesFactory typesFactory
	@Inject SolidityFactory solidityFactory
	
	override BuiltInDeclarations create(EObject element) {
		return getBuiltInDeclarationsFor(calculatePragma(element)) 
	}
	override BuiltInDeclarations create(Resource resource) {
		return getBuiltInDeclarationsFor(calculatePragma(resource)) 
	}
	def private String calculatePragma(Resource resource) {
		var PragmaDirective pragma=(EcoreUtil2.eAllContentsAsList(resource).stream().filter([eObject | eObject instanceof PragmaDirective]).findFirst().orElseGet([null]) as PragmaDirective) 
		if (pragma !== null) {
			return pragma.getVersion() 
		}
		return DEFAULT_SOLIDITY_VERSION 
	}
	def private String calculatePragma(EObject element) {
		var PragmaDirective pragma=((EcoreUtil2.getContainerOfType(element, SourceUnit).getPragma() as PragmaDirective)) 
		if (pragma !== null) {
			return pragma.getVersion() 
		}
		return DEFAULT_SOLIDITY_VERSION 
	}
	def private BuiltInDeclarations getBuiltInDeclarationsFor(String version) {
		
		switch (version) {
			case ZERO_FIVE_ZERO: {
				return new BuiltInDeclarations(typeSystem,typesFactory,solidityFactory) {
				
					Property abi
					
					override protected initialize() {
						super.initialize()
						abi = createConstant("abi", SolidityTypeSystem.ABI.typeForName);
					}

					override all() {
						#[msg, assert_, require, revert, abi, addmod, mulmod, keccak256, sha3, sha256, length, push, ripemd160,
							ecrecover, block, suicide, selfdestruct, this_, super_, now, tx, owned, mortal]
					}

					override protected Operation keccak256() {
						createOperation("keccak256", BYTES32) => [
							parameters += createParameter("argument", SolidityTypeSystem.BYTES.typeForName) => [
								optional = false
								varArgs = false
							]
						]
					}				
				}
			}
			default :{
				return new BuiltInDeclarations(typeSystem,typesFactory,solidityFactory) 
			}
		}
	}
}