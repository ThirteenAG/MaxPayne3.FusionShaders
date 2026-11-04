sampler2D DiffuseSampler : register(s0);
sampler2D EnvironmentSampler : register(s2);
sampler2D SpecSampler : register(s1);
float fresnelRolloff : register(c200);
float4 gAmbientOcclusionEffect : register(c63);
float4 gStencil : register(c61);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float reflectivePower : register(c199);
float4 specMapExpMask : register(c198);
float3 specMapIntMask : register(c197);
float3 specMapReflectMask : register(c201);
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
	float4 color2 : COLOR2;
	float4 color : COLOR;
	float4 color1 : COLOR1;
	float4 color3 : COLOR3;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	float3 r5;
	r0 = tex2D(DiffuseSampler, i.texcoord.xy);
	r0.w = r0.w * i.color.w;
	r1.x = r0.w * globalScalars.x;
	r1.yz = 0.5 * i.vpos.xy;
	r1.yz = frac(abs(r1.yz));
	r1.yz = (i.vpos.xy >= 0) ? r1.yz : -r1.yz;
	r1.yz = r1.yz + r1.yz;
	r2.xy = frac(r1.yz);
	r1.yz = r1.yz + -r2.xy;
	r1.y = r1.z * 2 + r1.y;
	r2 = r1.y + float4(-0, -1, -2, -3);
	r2 = (-abs(r2) >= 0) ? 1 : 0;
	r1.y = dot(stipplePattern, r2);
	r0.w = r0.w * -globalScalars.x + r1.y;
	r2 = (r0.w >= 0) ? -1 : -0;
	clip(r2);
	r1.yzw = 1E-05 + i.texcoord1.xyz;
	r2.xyz = normalize(r1.yzw);
	r3 = tex2D(SpecSampler, i.texcoord.xy);
	r0.w = dot(r3, specMapExpMask);
	r1.y = r0.w * specularFactor.x;
	o.color2.x = dot(r3.xyz, specMapIntMask.xyz);
	r1.z = 1;
	r0.w = r0.w * -specularFactor.x + r1.z;
	r4.xyz = 1E-05 + i.texcoord3.xyz;
	r5 = normalize(r4.xyz);
	r1.w = dot(-r5.xyz, r2.xyz);
	r1.w = r1.w + r1.w;
	r4.xyz = r2.xyz * -r1.www + -r5.xyz;
	r4.xyz = r4.xyz + 1E-05;
	r1.w = dot(r4.xyz, r4.xyz);
	r1.w = rsqrt(r1.w);
	r4.xy = r4.xz * r1.ww + 1;
	r4.xy = r4.xy * -0.5;
	r4 = tex2D(EnvironmentSampler, r4.xy);
	r1.w = saturate(dot(r5.xyz, r2.xyz));
	r1.z = r1.z + -fresnelRolloff.x;
	r1.w = -r1.w + 1.00001;
	r2.w = r1.w * r1.w;
	r2.w = r2.w * r2.w;
	r1.w = r1.w * r2.w;
	r1.z = fresnelRolloff.x * r1.w + r1.z;
	r4.xyz = r1.zzz * r4.xyz;
	r4.xyz = r4.xyz * reflectivePower.xxx;
	r1.z = dot(r3.xyz, specMapReflectMask.xyz);
	r3.xyz = r1.zzz * r4.xyz;
	r3.xyz = r3.xyz * globalScalars.www;
	r1.z = saturate(-1 + i.color.x);
	o.color.xyz = r1.zzz * globalScalars2.zzz + r0.xyz;
	o.color1.xyz = r2.xyz * 0.5 + 0.5;
	r0.x = saturate(r1.y * 0.0051020407);
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	o.color2.y = (r0.w >= 0) ? 0.26726124 : r0.x;
	o.color2.z = gAmbientOcclusionEffect.w * i.color.x;
	r0.xyz = saturate(r3.xyz * 0.0625);
	r0.x = rsqrt(r0.x);
	r0.y = rsqrt(r0.y);
	r0.z = rsqrt(r0.z);
	o.color3.x = 1 / r0.x;
	o.color3.y = 1 / r0.y;
	o.color3.z = 1 / r0.z;
	o.color.w = r1.x;
	o.color1.w = r1.x;
	o.color2.w = r1.x;
	o.color3.w = gStencil.x;

	return o;
}
