/**
 * Copyright (c) 2018 committers of YAKINDU and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 * 
 * Contributors:
 * 	Andreas Muelder - Itemis AG - initial API and implementation
 * 	Karsten Thoms   - Itemis AG - initial API and implementation
 * 	Florian Antony  - Itemis AG - initial API and implementation
 * 	committers of YAKINDU 
 * 
 */
package com.yakindu.solidity.typesystem;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.xtext.EcoreUtil2;
import org.yakindu.base.types.Operation;
import org.yakindu.base.types.TypesFactory;
import org.yakindu.base.types.typesystem.ITypeSystem;

import com.google.inject.Inject;
import com.google.inject.Singleton;
import com.yakindu.solidity.solidity.PragmaDirective;
import com.yakindu.solidity.solidity.SolidityFactory;
import com.yakindu.solidity.solidity.SourceUnit;

/**
 * @author Florian Antony - Initial contribution and API
 */
@Singleton
public class BuiltInDeclarationsFactory {

	public static final String DEFAULT_SOLIDITY_VERSION = "^0.4.23";
	public static final String ZERO_FIVE_ZERO = "^0.5.0";

	@Inject
	private ITypeSystem typeSystem;
	@Inject
	private TypesFactory typesFactory;
	@Inject
	private SolidityFactory solidityFactory;

	public BuiltInDeclarations create(EObject element) {
		return getBuiltInDeclarationsFor(calculatePragma(element));
	}

	public BuiltInDeclarations create(Resource resource) {
		return getBuiltInDeclarationsFor(calculatePragma(resource));
	}

	private String calculatePragma(Resource resource) {
		PragmaDirective pragma = (PragmaDirective) EcoreUtil2.eAllContentsAsList(resource).stream()
				.filter(eObject -> eObject instanceof PragmaDirective).findFirst().orElseGet(() -> null);
		if (pragma != null) {
			return pragma.getVersion();
		}
		return DEFAULT_SOLIDITY_VERSION;
	}

	private String calculatePragma(EObject element) {
		PragmaDirective pragma = ((PragmaDirective) EcoreUtil2.getContainerOfType(element, SourceUnit.class).getPragma());
		if (pragma != null) {
			return pragma.getVersion();
		}
		return DEFAULT_SOLIDITY_VERSION;
	}

	private BuiltInDeclarations getBuiltInDeclarationsFor(String version) {
		switch (version) {
		case ZERO_FIVE_ZERO:
			return new BuiltInDeclarations(typeSystem, typesFactory, solidityFactory) {

				// TODO implement changes
				@Override
				protected Operation keccak256() {

					return super.keccak256();
				}
			};
		default:
			return new BuiltInDeclarations(typeSystem, typesFactory, solidityFactory);
		}
	}
}
