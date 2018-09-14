package com.yakindu.solidity.typesystem.builtin;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.resource.Resource;

public interface IBuiltInDeclarationsFactory {

	public BuiltInDeclarations create(EObject element);

	public BuiltInDeclarations create(Resource resource);
}
