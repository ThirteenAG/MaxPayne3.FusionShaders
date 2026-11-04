sampler2D DiffuseSampler : register(s0);
sampler2D DynamicEnvironmentSampler : register(s13);
float fresnelRolloff : register(c199);
float4 gAdrenoFXVars : register(c68);
float4 gAmbientOcclusionEffect : register(c63);
float4 gStencil : register(c61);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float reflectivePower : register(c198);
float specularColorFactor : register(c197);
float specularFactor : register(c196);
float4 stipplePattern : register(c62);

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float3 texcoord3 : TEXCOORD3;
	float2 vpos : VPOS;
};

struct PS_OUT
{
	float4 color : COLOR;
	float4 color1 : COLOR1;
	float4 color2 : COLOR2;
	float4 color3 : COLOR3;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float3 r4;
	float3 r5;
	r0 = tex2D(DiffuseSampler, i.texcoord.xy);
	r1.xyz = 1E-05 + i.texcoord1.xyz;
	r2.xyz = normalize(r1.xyz);
	r1.yz = float2(1, 0);
	r2.w = max(r1.y, specularFactor.x);
	if (-reflectivePower.x < r1.z) {
		r1.x = saturate(r2.w * 0.015625);
		r3.w = r1.x * -4 + 4;
		r1.xzw = 1E-05 + i.texcoord3.xyz;
		r4 = normalize(r1.xzw);
		r1.x = dot(-r4.xyz, r2.xyz);
		r1.x = r1.x + r1.x;
		r1.xzw = r2.xyz * -r1.xxx + -r4.xyz;
		r1.xzw = r1.xzw + 1E-05;
		r5 = normalize(r1.xzw);
		r1.x = saturate(r5.z);
		r1.x = r1.x + 1;
		r1.x = r1.x + r1.x;
		r1.x = 1 / r1.x;
		r1.xz = r5.xy * r1.xx + 0.5;
		r3.xy = -r1.xz + 1;
		r3.z = 0;
		r3 = tex2Dlod(DynamicEnvironmentSampler, r3);
		r1.xzw = r3.xyz * r3.xyz;
		r1.xzw = r1.xzw * 16;
		r3.x = saturate(dot(r4.xyz, r2.xyz));
		r1.y = r1.y + -fresnelRolloff.x;
		r3.x = -r3.x + 1.00001;
		r4.x = pow(r3.x, 5.00001);
		r1.y = fresnelRolloff.x * r4.x + r1.y;
		r1.xyz = r1.yyy * r1.xzw;
	} else {
		r1.xyz = 0;
	}
	r0.w = r0.w * i.color.w;
	r1.w = r0.w * globalScalars.x;
	r3.xy = 0.5 * i.vpos.xy;
	r3.xy = frac(abs(r3.xy));
	r3.xy = (i.vpos.xy >= 0) ? r3.xy : -r3.xy;
	r3.xy = r3.xy + r3.xy;
	r3.zw = frac(r3.xy);
	r3.xy = -r3.zw + r3.xy;
	r3.x = r3.y * 2 + r3.x;
	r3 = r3.x + float4(-0, -1, -2, -3);
	r3 = (-abs(r3) >= 0) ? 1 : 0;
	r3.x = dot(stipplePattern, r3);
	r0.w = r0.w * -globalScalars.x + r3.x;
	r3 = (r0.w >= 0) ? -1 : -0;
	clip(r3);
	r1.xyz = r1.xyz * reflectivePower.xxx;
	r0.w = saturate(globalScalars.w);
	r1.xyz = r0.www * r1.xyz;
	r0.w = dot(r0.xyz, float3(0.2125, 0.7154, 0.0721));
	r3.xyz = lerp(r0.www, r0.xyz, gAdrenoFXVars.xxx);
	r0.w = saturate(gAmbientOcclusionEffect.z + gAmbientOcclusionEffect.z);
	r4 = lerp(r0.xyz, r3.xyz, r0.www);
	r0.x = saturate(-1 + i.color.x);
	o.color.xyz = r0.xxx * globalScalars2.zzz + r4.xyz;
	o.color1.xyz = r2.xyz * 0.5 + 0.5;
	r0.x = saturate(r2.w * 0.0051020407);
	r0.x = rsqrt(r0.x);
	o.color2.y = 1 / r0.x;
	r0.xyz = saturate(r1.xyz * 0.0625);
	r0.x = rsqrt(r0.x);
	r0.y = rsqrt(r0.y);
	r0.z = rsqrt(r0.z);
	o.color3.x = 1 / r0.x;
	o.color3.y = 1 / r0.y;
	o.color3.z = 1 / r0.z;
	o.color.w = r1.w;
	o.color1.w = r1.w;
	o.color2.x = specularColorFactor.x;
	o.color2.z = i.color.x;
	o.color2.w = r1.w;
	o.color3.w = gStencil.x;

	return o;
}
