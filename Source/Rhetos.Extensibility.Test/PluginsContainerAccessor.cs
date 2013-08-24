﻿using Autofac.Features.Metadata;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Rhetos.Extensibility.Test
{
    public class PluginsContainerAccessor<TPlugin> : PluginsContainer<TPlugin>
    {
        public PluginsContainerAccessor()
            : base(new Meta<Func<TPlugin>>[] { })
        {
        }

        public static List<Type> Access_GetTypeHierarchy(Type type)
        {
            return GetTypeHierarchy(type);
        }
    }
}
