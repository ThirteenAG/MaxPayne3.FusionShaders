sampler2D BumpSampler : register(s2);
sampler2D DiffuseSampler : register(s0);
sampler2D DynamicEnvironmentSampler : register(s13);
float bumpiness : register(c200);
float fresnelRolloff : register(c202);
float4 gAdrenoFXVars : register(c68);
float4 gAmbientOcclusionEffect : register(c63);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float reflectivePower : register(c201);
float specularColorFactor : register(c199);
float specularFactor : register(c198);
float4 stipplePattern : register(c62);

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float3 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
	float4 texcoord2 : TEXCOORD2;
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
	float4 r4;
	float3 r5;
	float3 r6;
	r0.xz = i.texcoord2.xz;
	r1.xy = max(i.texcoord.xy, r0.xz);
	r0.xy = min(i.texcoord2.yw, r1.xy);
	r0.zw = saturate(r0.xy);
	r1 = tex2D(BumpSampler, r0.xy);
	r0.x = -r1.w + 1;
	r0.x = -r1.x + r0.x;
	r0.xy = (r0.xx >= 0) ? r1.wy : r1.xy;
	r1 = tex2D(DiffuseSampler, r0.zw);
	r0.xy = r0.xy * 2 + -1;
	r0.xy = r0.xy * bumpiness.xx;
	r0.z = dot(r0.xy, -r0.xy) + 1;
	r2.x = max(r0.z, 0);
	r0.z = rsqrt(r2.x);
	r0.z = 1 / r0.z;
	r2.xw = float2(1, 0);
	r0.w = max(r2.x, specularFactor.x);
	r3.xyz = r0.xxx * i.texcoord4.xyz;
	r3.xyz = r0.zzz * i.texcoord1.xyz + r3.xyz;
	r0.xyz = r0.yyy * i.texcoord5.xyz + r3.xyz;
	r0.xyz = r0.xyz + 1E-05;
	r3.xyz = normalize(r0.xyz);
	if (-reflectivePower.x < r2.w) {
		r0.x = saturate(r0.w * 0.015625);
		r4.w = r0.x * -4 + 4;
		r0.xyz = 1E-05 + i.texcoord3.xyz;
		r5 = normalize(r0.xyz);
		r0.x = dot(-r5.xyz, r3.xyz);
		r0.x = r0.x + r0.x;
		r0.xyz = r3.xyz * -r0.xxx + -r5.xyz;
		r0.xyz = r0.xyz + 1E-05;
		r6 = normalize(r0.xyz);
		r0.x = saturate(r6.z);
		r0.x = r0.x + 1;
		r0.x = r0.x + r0.x;
		r0.x = 1 / r0.x;
		r0.xy = r6.xy * r0.xx + 0.5;
		r4.xy = -r0.xy + 1;
		r4.z = 0;
		r4 = tex2Dlod(DynamicEnvironmentSampler, r4);
		r0.xyz = r4.xyz * r4.xyz;
		r0.xyz = r0.xyz * 16;
		r2.y = saturate(dot(r5.xyz, r3.xyz));
		r2.x = r2.x + -fresnelRolloff.x;
		r2.y = -r2.y + 1.00001;
		r3.w = pow(r2.y, 5.00001);
		r2.x = fresnelRolloff.x * r3.w + r2.x;
		r0.xyz = r0.xyz * r2.xxx;
	} else {
		r0.xyz = 0;
	}
	r2 = r1.w + -0.01;
	clip(r2);
	r1.w = r1.w * i.color.w;
	r2.x = r1.w * globalScalars.x;
	r2.yz = 0.5 * i.vpos.xy;
	r2.yz = frac(abs(r2.yz));
	r2.yz = (i.vpos.xy >= 0) ? r2.yz : -r2.yz;
	r2.yz = r2.yz + r2.yz;
	r4.xy = frac(r2.yz);
	r2.yz = r2.yz + -r4.xy;
	r2.y = r2.z * 2 + r2.y;
	r4 = r2.y + float4(-0, -1, -2, -3);
	r4 = (-abs(r4) >= 0) ? 1 : 0;
	r2.y = dot(stipplePattern, r4);
	r1.w = r1.w * -globalScalars.x + r2.y;
	r4 = (r1.w >= 0) ? -1 : -0;
	clip(r4);
	r0.xyz = r0.xyz * reflectivePower.xxx;
	r0.xyz = r0.xyz * globalScalars.www;
	r1.w = dot(r1.xyz, float3(0.2125, 0.7154, 0.0721));
	r2.yzw = lerp(r1.www, r1.xyz, gAdrenoFXVars.yyy);
	r1.w = saturate(gAmbientOcclusionEffect.z + gAmbientOcclusionEffect.z);
	r4.xyz = lerp(r1.xyz, r2.yzw, r1.www);
	r1.x = saturate(-1 + i.color.x);
	o.color.xyz = r1.xxx * globalScalars2.zzz + r4.xyz;
	o.color1.xyz = r3.xyz * 0.5 + 0.5;
	r0.w = saturate(r0.w * 0.0051020407);
	r0.w = rsqrt(r0.w);
	o.color2.y = 1 / r0.w;
	r0.xyz = saturate(r0.xyz * 0.0625);
	r0.x = rsqrt(r0.x);
	r0.y = rsqrt(r0.y);
	r0.z = rsqrt(r0.z);
	o.color3.x = 1 / r0.x;
	o.color3.y = 1 / r0.y;
	o.color3.z = 1 / r0.z;
	o.color.w = r2.x;
	o.color1.w = r2.x;
	o.color2.x = specularColorFactor.x;
	o.color2.z = i.color.x;
	o.color2.w = r2.x;
	o.color3.w = r2.x;

	return o;
}
