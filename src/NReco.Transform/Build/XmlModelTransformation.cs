﻿using System;
using System.Collections.Generic;
using System.Reflection;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.IO;
using System.Resources;
using Microsoft.Build.Framework;
using Microsoft.Build.Utilities;


namespace NReco.Transform.Build {
	
	/// <summary>
	/// XmlModelTransformation MSBuild task implementation
	/// </summary>
	public class XmlModelTransformation : Task {

		[Required]
		public string RootPath { get; set; }

		[Required]
		public ITaskItem[] XmlModels { get; set; }

		[Output]
		public string[] GeneratedFiles { get; set; }

		protected XmlModelProcessor ModelProcessor;

		public XmlModelTransformation() {
		}

		public override bool Execute() {
			ModelProcessor = new XmlModelProcessor(RootPath);
			
			var generatedFiles = new List<string>();
			foreach (var xmlModel in XmlModels) {
				if (xmlModel.ItemSpec.Length > 0) {
					var xmlModelPath = xmlModel.ItemSpec;
					Log.LogMessage(MessageImportance.Normal, "Processing XML model {0}", xmlModelPath);
					generatedFiles.AddRange( ModelProcessor.TransformModel(xmlModelPath) );
				}
			}
			GeneratedFiles = generatedFiles.ToArray();
			return true;
		}

	}
}
