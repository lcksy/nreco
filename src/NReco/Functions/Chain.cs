#region License
/*
 * NReco library (http://nreco.googlecode.com/)
 * Copyright 2008-2014 Vitaliy Fedorchenko
 * Distributed under the LGPL licence
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#endregion

using System;
using System.Collections.Generic;
using System.Text;
using NReco.Converting;

namespace NReco.Functions {

	/// <summary>
	/// Chain of actions
	/// </summary>
	public class Chain {

		public string ChainResult { get; set; }

		public string ChainArgument { get; set; }
		
		/// <summary>
		/// Get or set chain operations list.
		/// </summary>
		public Action<IDictionary<string,object>>[] Actions { get; set; }

		public Chain(Action<IDictionary<string,object>>[] actions, string argName, string resultName) {
			Actions = actions;
			ChainArgument = argName;
			ChainResult = resultName;
		}

		public object Invoke(object arg) {
			var context = new Dictionary<string, object>();
			context[ChainArgument] = context;

			for (int i = 0; i < Actions.Length; i++)
				Actions[i](context);

			return context.ContainsKey(ChainResult) ? context[ChainResult] : null;
		}


	}


}
