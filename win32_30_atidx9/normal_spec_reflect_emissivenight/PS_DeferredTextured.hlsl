sampler2D BumpSampler : register(s1);
sampler2D DiffuseSampler : register(s0);
sampler2D EnvironmentSampler : register(s3);
sampler2D SpecSampler : register(s2);
float bumpiness : register(c203);
float4 colorize : register(c47);
float fresnelRolloff : register(c205);
float4 gAdrenoFXVars : register(c68);
float4 gAmbientOcclusionEffect : register(c63);
float4 gStencil : register(c61);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float reflectivePower : register(c204);
float4 specMapExpMask : register(c202);
float3 specMapIntMask : register(c201);
float3 specMapReflectMask : register(c206);
float specularFactor : register(c200);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float3 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
	float4 color : COLOR;
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
	r0 = tex2D(SpecSampler, i.texcoord.xy);
	o.color2.x = dot(r0.xyz, specMapIntMask.xyz);
	r1 = tex2D(DiffuseSampler, i.texcoord.xy);
	r2 = r1 * colorize;
	r1.w = dot(r2.xyz, float3(0.2125, 0.7154, 0.0721));
	r3.xyz = r1.xyz * colorize.xyz + -r1.www;
	r3.xyz = gAdrenoFXVars.xxx * r3.xyz + r1.www;
	r1.xyz = r1.xyz * -colorize.xyz + r3.xyz;
	r1.w = saturate(gAmbientOcclusionEffect.z + gAmbientOcclusionEffect.z);
	r1.xyz = r1.www * r1.xyz + r2.xyz;
	r1.w = r2.w * i.color.w;
	r1.w = r1.w * globalScalars.x;
	r2.xz = float2(1, -1);
	r2.y = saturate(r2.z + globalScalars.z);
	o.color.xyz = r2.yyy * globalScalars2.zzz + r1.xyz;
	r3 = tex2D(BumpSampler, i.texcoord.xy);
	r1.x = -r3.w + 1;
	r1.x = -r3.x + r1.x;
	r1.xy = (r1.xx >= 0) ? r3.wy : r3.xy;
	r1.xy = r1.xy * 2 + -1;
	r1.xy = r1.xy * bumpiness.xx;
	r1.z = dot(r1.xy, -r1.xy) + 1;
	r2.y = max(r1.z, 0);
	r1.z = rsqrt(r2.y);
	r1.z = 1 / r1.z;
	r2.yzw = r1.xxx * i.texcoord4.xyz;
	r2.yzw = r1.zzz * i.texcoord1.xyz + r2.yzw;
	r1.xyz = r1.yyy * i.texcoord5.xyz + r2.yzw;
	r1.xyz = r1.xyz + 1E-05;
	r3.xyz = normalize(r1.xyz);
	o.color1.xyz = r3.xyz * 0.5 + 0.5;
	r0.w = dot(r0, specMapExpMask);
	r0.x = dot(r0.xyz, specMapReflectMask.xyz);
	r0.y = r0.w * specularFactor.x;
	r0.z = r0.w * -specularFactor.x + r2.x;
	r0.y = saturate(r0.y * 0.0051020407);
	r0.y = rsqrt(r0.y);
	r0.y = 1 / r0.y;
	o.color2.y = (r0.z >= 0) ? 0.071428575 : r0.y;
	r0.yzw = 1E-05 + i.texcoord3.xyz;
	r1.xyz = normalize(r0.yzw);
	r0.y = dot(-r1.xyz, r3.xyz);
	r0.y = r0.y + r0.y;
	r0.yzw = r3.xyz * -r0.yyy + -r1.xyz;
	r1.x = saturate(dot(r1.xyz, r3.xyz));
	r1.x = -r1.x + 1.00001;
	r2.y = pow(r1.x, 5.00001);
	r0.yzw = r0.yzw + 1E-05;
	r0.z = dot(r0.yzw, r0.yzw);
	r0.z = rsqrt(r0.z);
	r0.yz = r0.yw * r0.zz + 1;
	r0.yz = r0.yz * -0.5;
	r3 = tex2D(EnvironmentSampler, r0.yz);
	r0.y = r2.x + -fresnelRolloff.x;
	r0.y = fresnelRolloff.x * r2.y + r0.y;
	r0.yzw = r0.yyy * r3.xyz;
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
	o.color.w = r1.w;
	o.color1.w = r1.w;
	o.color2.w = r1.w;
	o.color2.z = globalScalars.z;
	o.color3.w = gStencil.x;

	return o;
}
