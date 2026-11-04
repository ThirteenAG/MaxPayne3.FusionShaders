sampler2D BumpSampler : register(s1);
sampler2D DiffuseSampler : register(s0);
samplerCUBE EnvironmentSampler : register(s3);
sampler2D SpecSampler : register(s2);
float bumpiness : register(c199);
float fresnelRolloff : register(c201);
float4 gAdrenoFXVars : register(c68);
float4 gAmbientOcclusionEffect : register(c63);
float4 gStencil : register(c61);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float reflectivePower : register(c200);
float4 specMapExpMask : register(c198);
float3 specMapIntMask : register(c197);
float3 specMapReflectMask : register(c202);
float specularFactor : register(c196);

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float3 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
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
	float3 r3;
	float4 r4;
	r0 = tex2D(SpecSampler, i.texcoord.xy);
	o.color2.x = dot(r0.xyz, specMapIntMask.xyz);
	r1.x = saturate(gAmbientOcclusionEffect.z + gAmbientOcclusionEffect.z);
	r2 = tex2D(DiffuseSampler, i.texcoord.xy);
	r1.y = dot(r2.xyz, float3(0.2125, 0.7154, 0.0721));
	r3 = lerp(r1.yyy, r2.xyz, gAdrenoFXVars.xxx);
	r4.xyz = lerp(r2.xyz, r3.xyz, r1.xxx);
	r1.x = r2.w * i.color.w;
	r1.x = r1.x * globalScalars.x;
	r1.y = saturate(-1 + i.color.x);
	o.color.xyz = r1.yyy * globalScalars2.zzz + r4.xyz;
	r2 = tex2D(BumpSampler, i.texcoord.xy);
	r1.y = -r2.w + 1;
	r1.y = -r2.x + r1.y;
	r1.yz = (r1.yy >= 0) ? r2.wy : r2.xy;
	r1.yz = r1.yz * 2 + -1;
	r1.yz = r1.yz * bumpiness.xx;
	r1.w = dot(r1.yz, -r1.yz) + 1;
	r2.x = max(r1.w, 0);
	r1.w = rsqrt(r2.x);
	r1.w = 1 / r1.w;
	r2.xyz = r1.yyy * i.texcoord4.xyz;
	r2.xyz = r1.www * i.texcoord1.xyz + r2.xyz;
	r1.yzw = r1.zzz * i.texcoord5.xyz + r2.xyz;
	r1.yzw = r1.yzw + 1E-05;
	r2.xyz = normalize(r1.yzw);
	o.color1.xyz = r2.xyz * 0.5 + 0.5;
	r0.w = dot(r0, specMapExpMask);
	r0.x = dot(r0.xyz, specMapReflectMask.xyz);
	r0.y = r0.w * specularFactor.x;
	r3.x = 1;
	r0.z = r0.w * -specularFactor.x + r3.x;
	r0.y = saturate(r0.y * 0.0051020407);
	r0.y = rsqrt(r0.y);
	r0.y = 1 / r0.y;
	o.color2.y = (r0.z >= 0) ? 0.071428575 : r0.y;
	r0.yzw = 1E-05 + i.texcoord3.xyz;
	r4.xyz = normalize(r0.yzw);
	r0.y = dot(-r4.xyz, r2.xyz);
	r0.y = r0.y + r0.y;
	r0.yzw = r2.xzy * -r0.yyy + -r4.xzy;
	r1.y = saturate(dot(r4.xyz, r2.xyz));
	r1.y = -r1.y + 1.00001;
	r2.x = pow(r1.y, 5.00001);
	r0.yzw = r0.yzw + 1E-05;
	r1.y = dot(r0.yzw, r0.yzw);
	r1.y = rsqrt(r1.y);
	r0.yzw = r0.yzw * r1.yyy;
	r4 = texCUBE(EnvironmentSampler, r0.yzw);
	r0.y = r3.x + -fresnelRolloff.x;
	r0.y = fresnelRolloff.x * r2.x + r0.y;
	r0.yzw = r0.yyy * r4.xyz;
	r0.yzw = r0.yzw * reflectivePower.xxx;
	r0.xyz = r0.xxx * r0.yzw;
	r0.xyz = r0.xyz * globalScalars.www;
	r0.xyz = saturate(r0.xyz * 0.0625);
	r0.x = rsqrt(r0.x);
	o.color3.x = 1 / r0.x;
	r0.x = rsqrt(r0.y);
	r0.y = rsqrt(r0.z);
	o.color3.z = 1 / r0.y;
	o.color3.y = 1 / r0.x;
	o.color.w = r1.x;
	o.color1.w = r1.x;
	o.color2.w = r1.x;
	o.color2.z = i.color.x;
	o.color3.w = gStencil.x;

	return o;
}
